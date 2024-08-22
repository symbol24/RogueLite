class_name Rat extends REnemy

func _ready() -> void:
	super()

func attack_move_forward() -> void:
	var move_by := 10 if !flipped else -10
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(global_position.x + move_by, global_position.y), 0.1)

func attack_move_back():
	var move_by := 10 if !flipped else -10
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "global_position", Vector2(global_position.x - move_by, global_position.y), 0.1)
