class_name RCamera extends Camera2D

func _ready():
	Signals.UpdateInputFocus.emit(RInput.FOCUS.GAMEPLAY)
