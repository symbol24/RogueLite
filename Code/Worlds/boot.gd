extends Node2D

func _ready() -> void:
	Debug.log("GM.is_debug ", GM.is_debug)
	await get_tree().create_timer(0.5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Debug.log(Input.mouse_mode)
	Signals.Load.emit()
	await get_tree().create_timer(2).timeout
	Signals.LoadNewWorld.emit("main_menu")
