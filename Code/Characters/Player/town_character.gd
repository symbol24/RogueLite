class_name TownCharacter extends RCharacter

const MOVE = "res://Scenes/Characters/Player/Actions/move.tscn"

@onready var camera_remote:RRemoteTransform2D = %camera_remote
@onready var state_machine:RStateMachine = %state_machine

var actions := []

func _ready() -> void:
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	data = character_data.duplicate()
	data.setup_data()
	_contruct_actions()
	if animator.is_node_ready():
		items_to_flip = _get_flip(self)
		Signals.CharacterReady.emit(self)
		Signals.UpdateAllCurrencies.emit()

func _contruct_actions() -> void:
	var array:Array = []
	if data.helmet != null:
		array.append_array(data.helmet.get_instantiated_actions())
	if data.chest != null:
		array.append_array(data.chest.get_instantiated_actions())
	if data.pants != null:
		array.append_array(data.pants.get_instantiated_actions())
	else:
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
		if each.action_type in [RAction.TYPE.BOTH, RAction.TYPE.TOWN]:
			actions.append(each)
			add_child.call_deferred(each)

func _physics_process(_delta):
	if GM.is_playing():
		grounded = is_on_floor_only()
		if !grounded: _apply_gravity(_delta)
		
		if _get_can_move():
			move_and_slide()
		
		if state_machine.can_flip:
			_flip_items(items_to_flip, direction, sprite)

func _get_can_move() -> bool:
	if state_machine:
		return state_machine.can_move
	return false
