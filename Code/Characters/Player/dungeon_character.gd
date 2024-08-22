class_name DungeonCharacter extends RCharacter

const JUMP = "res://Scenes/Characters/Player/Actions/jump.tscn"
const MOVE = "res://Scenes/Characters/Player/Actions/move.tscn"

@onready var camera_remote:RRemoteTransform2D = %camera_remote
@onready var state_machine:RStateMachine = %state_machine
@onready var dmg_marker:Marker2D = %dmg_numbers

var actions := []

func _ready() -> void:
	Signals.DebugToggleGodMode.connect(_toggle_god_mode)
	Signals.DebugCharacterHit.connect(_debug_character_hit)
	Signals.DebugAddMaxHP.connect(_debug_update_max_hp)
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	Signals.StartAttack.connect(_start_attack)
	Signals.AttackReceived.connect(_character_hit)
	Signals.CharacterDead.connect(_death)
	#Debug.log(character_data)
	data = character_data.duplicate()
	data.setup_data()
	#await Signals.DataSetupDone
	_contruct_actions()
	if animator.is_node_ready():
		items_to_flip = _get_flip(self)
		Signals.CharacterReady.emit(self)
		Signals.UpdateAllCurrencies.emit()
		#Debug.log("Character ", name, " ready.")

func _contruct_actions() -> void:
	var array:Array = []
	if data.helmet != null:
		array.append_array(data.helmet.get_instantiated_actions())
	if data.chest != null:
		array.append_array(data.chest.get_instantiated_actions())
	if data.pants != null:
		array.append_array(data.pants.get_instantiated_actions())
	else:
		var jump = load(JUMP).instantiate()
		array.append(jump)
		var move = load(MOVE).instantiate()
		array.append(move)
	if data.acc1 != null:
		array.append_array(data.acc1.get_instantiated_actions())
	if data.acc2 != null:
		array.append_array(data.acc2.get_instantiated_actions())
	if data.weapon != null:
		var weapon_actions = data.weapon.get_instantiated_actions()
		if weapon_actions.is_empty(): Debug.error("No weapon gear data in character data.")
		array.append_array(weapon_actions)
	for each in array:
		if each.action_type in [RAction.TYPE.BOTH, RAction.TYPE.DUNGEON]:
			actions.append(each)
			add_child.call_deferred(each)

func _emit_signal(_id := "", _opt1 := "", _opt2 := ""):
	match _id:
		"end_land":
			Signals.UpdateCharacterState.emit(self, "idle")
		"toggle_attack":
			if _opt1 and _opt2:
				var is_enabled := false
				if _opt2 == "true": is_enabled = true
				Signals.ToggleAttackCollider.emit(_opt1, is_enabled)
		"attack_ended":
			if _opt1:
				Signals.AttackEnded.emit(self, _opt1)
		"end_run_check":
			Signals.EndRunCheck.emit()

func _physics_process(_delta):
	if GM.is_playing() and !state_machine.is_state("dead"):
		grounded = is_on_floor_only()
		if !grounded: _apply_gravity(_delta)
		
		if _get_can_move():
			move_and_slide()
		
		if state_machine.can_flip:
			_flip_items(items_to_flip, direction, sprite)

func _start_attack(_character:RCharacter, _name := ""):
	#Debug.log("Receiving ", _character.name, " and ", _name)
	if _character == self and _name:
		_update_animation(_name)
		Signals.UpdateCharacterState.emit(self, "attack")

func _character_hit(_owner:RCharacter = null, _dmgs:Array[Damage] = []):
	#Debug.log("owner: ", _owner, " and dmgs: ", _dmgs)
	if _owner == self and !_dmgs.is_empty():
		for dmg in _dmgs:
			var final_dmg = data.apply_damage(dmg.get_damage())
			#Debug.log(name, " has received ", final_dmg, " damages.")
			Signals.DisplayDmgNumber.emit(final_dmg, dmg.types, dmg.is_critical, dmg_marker)

func _get_can_move() -> bool:
	if state_machine:
		return state_machine.can_move
	return false

func _debug_character_hit(_dmg:Damage):
	if self == GM.character and _dmg:
		_character_hit(self, [_dmg])

func _debug_update_max_hp(_value := 0.0):
	if self == GM.character :
		data.max_hp += _value

func _death(_data:RCharacterData):
	if _data == data:
		Signals.UpdateCharacterState.emit(self, "dead")
		move_collider.set_deferred("disabled", true)
		Signals.ToggleHitCollider.emit(self, true)
