class_name RCharacter extends CharacterBody2D

@export var character_data:MainCharacterData

@onready var sprite:Sprite2D = %sprite
@onready var state_machine:RStateMachine = %RStateMachine
@onready var animator:AnimationPlayer = %animator

#Debug
var godmode := false

var data:RCharacterData
var items_to_flip := []
var direction := 0.0
var last_y := 0.0
var can_move := false:
	get:
		return _get_can_move()
var grounded := true:
	set(value):
		var pre_value = grounded
		grounded = value
		if pre_value != grounded: Signals.CharacterGrounded.emit(self)

func _ready():
	Signals.DebugToggleGodMode.connect(_toggle_god_mode)
	Signals.DebugCharacterHit.connect(_debug_character_hit)
	Signals.DebugAddMaxHP.connect(_debug_update_max_hp)
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	Signals.StartAttack.connect(_start_attack)
	#Debug.log(character_data)
	data = character_data.duplicate()
	data.setup_data()
	for child in get_children(true):
		if child.is_in_group("flip"):
			items_to_flip.append(child)
	if animator.is_node_ready():
		Signals.CharacterReady.emit(self)

func _physics_process(_delta):
	if GM.is_playing():
		grounded = is_on_floor_only()
		if !grounded: _apply_gravity(_delta)
		
		if state_machine.can_flip:
			_flip_items(items_to_flip, direction, sprite)
		
		#if velocity != Vector2.ZERO:
			#Debug.log("velocity ", velocity)
		
		if _get_can_move():
			move_and_slide()

func update_velocity(_value:float):
	velocity.x = _value

func update_direction(_value := 0.0):
	direction = _value

func _apply_gravity(_delta := 0.0):
	velocity.y += get_gravity() * _delta
	if velocity.y > 0.0:
		last_y = velocity.y

func get_gravity() -> float:
	return get_jump_gravity() if velocity.y < 0.0 else get_fall_gravity()
	
func get_jump_velocity() -> float:
	var height = 100.0
	if data: height = data.jump_height
	return -((2.0 * height) / GM.JUMP_TIME_TO_PEAK)

func get_jump_gravity() -> float:
	var height = 100.0
	if data: height = data.jump_height
	return ((2.0 * height) / (GM.JUMP_TIME_TO_PEAK * GM.JUMP_TIME_TO_PEAK))

func get_fall_gravity() -> float:
	var height := 100.0
	if data: height = data.jump_height
	return maxf(((2.0 * height) / (GM.JUMP_TIME_TO_DESCENT * GM.JUMP_TIME_TO_DESCENT)), GM.MAX_FALL_VELOCITY)

func _get_can_move() -> bool:
	if state_machine:
		return state_machine.can_move
	return false

func _update_animation_from_state(_character:RCharacter, _state:RState):
	if _character == self:
		if _state.animation: _update_animation(_state.animation)

func _update_animation(_new_anim := ""):
	if _new_anim in animator.get_animation_list():
		animator.play(_new_anim)
	else: print("Animation ", _new_anim, " not present in animtor")

func _emit_signal(_id := "", _opt1 := "", _opt2 := ""):
	match _id:
		"end_land":
			Signals.UpdateCharacterState.emit(self, "idle")
		"toggle_attack":
			if _opt1 and _opt2:
				var is_enabled := false
				if _opt2 == "true": is_enabled = true
				Signals.ToggleAttackCollier.emit(_opt1, is_enabled)
		"attack_ended":
			if _opt1:
				Signals.AttackEnded.emit(self, _opt1)

func _start_attack(_character:RCharacter, _name := ""):
	Debug.log("Receiving ", _character.name, " and ", _name)
	if _character == self and _name:
		_update_animation(_name)
		Signals.UpdateCharacterState.emit(self, "attack")

func _flip_items(_items := [], _x_vel := 0.0, _sprite:Sprite2D = null):
	for item in _items:
		if _x_vel > 0.0 and _sprite.flip_h and item.position.x < 0.0:
			item.position.x = -item.position.x
		elif _x_vel < 0.0 and !_sprite.flip_h and item.position.x > 0.0:
			item.position.x = -item.position.x
	if _x_vel > 0.0 and _sprite.flip_h:
		_sprite.flip_h = !_sprite.flip_h
	elif _x_vel < 0.0 and !_sprite.flip_h:
		_sprite.flip_h = !_sprite.flip_h

func _character_hit(_dmgs:Array[Damage] = []):
	if !_dmgs.is_empty():
		for dmg in _dmgs:
			data.apply_damage(dmg)

func _toggle_god_mode():
	godmode = !godmode

func _debug_character_hit(_dmg:Damage):
	if self == GM.character and _dmg:
		_character_hit([_dmg])

func _debug_update_max_hp(_value := 0.0):
	if self == GM.character :
		data.max_hp += _value
