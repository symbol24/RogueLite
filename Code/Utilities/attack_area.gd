class_name AttackArea extends RArea2D

@export var id := ""
@export var damages:Array[Damage] = []

var attack_colliders:Array[CollisionShape2D] = []
var r_owner:RCharacter

func _ready():
	Signals.ToggleAttackCollider.connect(_toggle_attack_collider)
	var temp = get_children()
	for each in temp:
		if each is CollisionShape2D:
			attack_colliders.append(each)
	r_owner = get_parent().get_parent()
	for each in damages:
		each.damage_owner = r_owner

func _toggle_attack_collider(_name := "", _value := false):
	if _name == id:
		for collider in attack_colliders:
			collider.disabled = !_value
