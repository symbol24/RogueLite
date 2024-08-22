class_name RTown extends RPlayWorld

func _ready() -> void:
	Signals.ToggleTownUI.emit(true)
	super()
