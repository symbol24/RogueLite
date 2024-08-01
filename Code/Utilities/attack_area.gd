class_name AttackArea extends Area2D

@export var id := ""
@export var damages:Array[Damage] = []

var attack_colliders:Array[CollisionShape2D] = []

func _ready():
	Signals.ToggleAttackCollier.connect(_toggle_attack_collider)
	var temp = get_children()
	for each in temp:
		if each is CollisionShape2D:
			attack_colliders.append(each)

func _toggle_attack_collider(_name := "", _value := false):
	if _name == id:
		for collider in attack_colliders:
			collider.disabled = !_value
