class_name REnemy extends RCharacter

enum STATE {IDLE = 0, WALK = 1, ATTACK = 2, DEAD = 3, CHASE = 4, WAIT = 5}

@onready var dmg_marker:Marker2D = %dmg_numbers
@onready var loot_spawn:Marker2D = %loot_spawn
@onready var get_character_timer: Timer = %get_character_timer

var target:DungeonCharacter
var distance_to_target := 0.0

var state := STATE.IDLE
var previous_state := STATE.IDLE
var flipped:bool:
	get:
		return sprite.flip_h

func _ready() -> void:
	Signals.AttackReceived.connect(_character_hit)
	Signals.CharacterDead.connect(_death)
	while character_data == null and !(character_data is RCharacterData):
		await get_tree().create_timer(0.1).timeout
	data = character_data.duplicate()
	data.setup_data(name)
	_set_character()
	if animator.is_node_ready():
		items_to_flip = _get_flip(self)
		Debug.log("ready? ", items_to_flip.size())
		Signals.CharacterReady.emit(self)

func _physics_process(_delta: float) -> void:
	if GM.is_playing() and state != STATE.DEAD:
		grounded = is_on_floor_only()
		if !grounded:
			_apply_gravity(_delta)

		match state:
			STATE.WALK:
				_move_to(_delta, direction)
			STATE.CHASE:
				direction = -1 if is_target_left() else 1
				_move_to(_delta, direction)
			_:
				_do_state(_delta, direction)

func idle() -> void:
	_update_animation("idle")
	direction = 0

func chase() -> void:
	_update_animation("walk")

func attack(_anim_name := ""):
	direction = 0
	_update_animation(_anim_name)

func _do_state(_delta := 0.0, _direction := 0.0) -> void:
	velocity.x = _direction
	move_and_slide()

func _move_to(_delta := 0.0, _direction := 0.0) -> void:
	var new_x = move_toward(velocity.x, _direction * data.speed, _delta * data.acceleration)
	velocity.x = new_x
	if is_target_left():
		if !flipped:
			flip()
	else:
		if flipped:
			flip()
	move_and_slide()

func _get_flip(_child) -> Array:
	var to_return := []
	if _child.get_children().size() > 0:
		for child in _child.get_children():
			if child.is_in_group("flip"): to_return.append(child)
			to_return.append_array(_get_flip(child))
	return to_return

func _set_character():
	if GM.character != null:
		target = GM.character
		if !get_character_timer.is_stopped():
			get_character_timer.stop()
	else:
		Debug.log("GM.character ", GM.character)
		if get_character_timer.is_stopped():
			if !get_character_timer.timeout.is_connected(_set_character):
				get_character_timer.timeout.connect(_set_character)
			get_character_timer.start()

func get_distance_to_target() -> float:
	if target != null:
		return global_position.distance_squared_to(target.global_position)
	return 10000000000000

func is_target_left() -> bool:
	return global_position.x > target.global_position.x

func _character_hit(_owner:RCharacter = null, _dmgs:Array[Damage] = []):
	if _owner == self and !_dmgs.is_empty():
		for dmg in _dmgs:
			var final_dmg = data.apply_damage(dmg.get_damage())
			#Debug.log(name, " has received ", final_dmg, " damages.")
			Signals.DisplayDmgNumber.emit(final_dmg, dmg.types, dmg.is_critical, dmg_marker)

func _death(_data:RCharacterData):
	if _data == data:
		state = STATE.DEAD
		_update_animation("death")
		move_collider.set_deferred("disabled", true)
		Signals.ToggleHitCollider.emit(self, true)

func _emit_signal(_id := "", _opt1 := "", _opt2 := ""):
	match _id:
		"spawn_loot":
			if loot_spawn != null:
				#Debug.log("Sending loot table: ", data.loot_table.id)
				Signals.SpawnFromLootTable.emit(data.loot_table, loot_spawn.global_position, GM.rng.randi_range(1, 5))
		_:
			pass

func end_death() -> void:
	queue_free.call_deferred()

func set_state(_new_state := STATE.IDLE) -> void:
	previous_state = state
	state = _new_state

func set_animation(_new_anim := "") -> void:
	_update_animation(_new_anim)

func is_animation_playing(_anim_name := "") -> bool:
	return animator.current_animation == _anim_name

func is_animation_over(_anim_name := "") -> bool:
	if animator.is_playing() and animator.current_animation == _anim_name: return false
	return true

func flip() -> void:
	_flip_items(items_to_flip, 0.0, sprite)

func _flip_items(_items := [], _x_vel := 0.0, _sprite:Sprite2D = null) -> void:
	for item in _items:
		if _sprite.flip_h and item.position.x < 0.0:
			item.position.x = -item.position.x
		elif !_sprite.flip_h and item.position.x > 0.0:
			item.position.x = -item.position.x
	if _sprite.flip_h:
		_sprite.flip_h = !_sprite.flip_h
	elif !_sprite.flip_h:
		_sprite.flip_h = !_sprite.flip_h
