class_name ProduceItem extends Node2D

@onready var highlight: Sprite2D = %highlight
@onready var spawn_point: Marker2D = %spawn_point

func toggle_highlight(_value:=false) -> void:
	highlight.visible = _value

func spawn_produce(_data:ProduceItemData) -> bool:
	var spawned := false
	if _data != null:
		Signals.SpawnOneItem.emit(_data, spawn_point.global_position)
		spawned = true
	return spawned
	
