extends Node2D

func _ready():
	Signals.LoadNewWorld.emit("main_menu")
