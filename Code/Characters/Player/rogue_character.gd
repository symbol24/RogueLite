class_name RCharacter extends CharacterBody2D

@export var character_data:RCharacterData

@onready var sprite:Sprite2D = %sprite
@onready var animator:AnimationPlayer = %animator
@onready var move_collider:CollisionShape2D = %move_collider

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
	data = character_data.duplicate()
	data.setup_data()
	if animator.is_node_ready():
		items_to_flip = _get_flip(self)
		Signals.CharacterReady.emit(self)

func _get_flip(_child) -> Array:
	var to_return := []
	if _child.get_children().size() > 0:
		for child in _child.get_children():
			if child.is_in_group("flip"): to_return.append(child)
			to_return.append_array(_get_flip(child))
	return to_return

func update_velocity(_value:float):
	velocity.x = _value

func update_direction(_value := 0.0):
	direction = _value

func _apply_gravity(_delta := 0.0):
	velocity.y += _get_gravity() * _delta
	if velocity.y > 0.0:
		last_y = velocity.y

func _get_gravity() -> float:
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
	return false

func _update_animation_from_state(_character:RCharacter, _state:RState):
	if _character == self:
		if _state.animation: _update_animation(_state.animation)

func _update_animation(_new_anim := ""):
	if _new_anim in animator.get_animation_list():
		animator.play(_new_anim)
	else: print("Animation ", _new_anim, " not present in animtor")

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

func _emit_signal(_id := "", _opt1 := "", _opt2 := ""):
	pass

func _character_hit(_owner:RCharacter = null, _dmgs:Array[Damage] = []):
	pass

func _toggle_god_mode():
	godmode = !godmode
