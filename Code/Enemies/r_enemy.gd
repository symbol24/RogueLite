class_name REnemy extends RCharacter

@onready var dmg_marker:Marker2D = %dmg_numbers

var target:DungeonCharater
var distance_to_target := 0.0

func _ready():
	Signals.AttackReceived.connect(_character_hit)
	Signals.CharacterDead.connect(_death)
	data = character_data.duplicate()
	data.setup_data(name)
	for child in get_children(true):
		if child.is_in_group("flip"):
			items_to_flip.append(child)
	if animator.is_node_ready():
		Signals.CharacterReady.emit(self)

func _physics_process(_delta):
	if GM.is_playing():
		grounded = is_on_floor_only()
		if !grounded: _apply_gravity(_delta)
		
		#direction = global_position.direction_to(target.global_position).normalized().x
		#
		#distance_to_target = _get_distance_to_target(target)
		
		#if _get_can_move():
			#move_and_slide()
		#
		#if state_machine.can_flip:
			#_flip_items(items_to_flip, direction, sprite)

func _get_distance_to_target(_target:DungeonCharater) -> float:
	return global_position.distance_squared_to(_target.global_position)

func _character_hit(_owner:RCharacter = null, _dmgs:Array[Damage] = []):
	if _owner == self and !_dmgs.is_empty():
		for dmg in _dmgs:
			var final_dmg = data.apply_damage(dmg.get_damage())
			#Debug.log(name, " has received ", final_dmg, " damages.")
			Signals.DisplayDmgNumber.emit(final_dmg, dmg.types, dmg.is_critical, dmg_marker)

func _death(_data:RCharacterData):
	if _data == data:
		_update_animation("death")
		move_collider.set_deferred("disabled", true)
		Signals.ToggleHitCollider.emit(self, true)
