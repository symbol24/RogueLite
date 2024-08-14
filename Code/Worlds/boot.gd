extends Node2D

func _ready():
	Debug.log("GM.is_debug ", GM.is_debug)
	await get_tree().create_timer(0.5).timeout
	Signals.Load.emit()
	await get_tree().create_timer(2).timeout
	Signals.LoadNewWorld.emit("main_menu")
