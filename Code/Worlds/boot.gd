extends Node2D

func _ready():
	Signals.Load.emit()
	await get_tree().create_timer(2).timeout
	Signals.LoadNewWorld.emit("main_menu")
