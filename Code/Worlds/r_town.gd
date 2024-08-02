class_name RTown extends RPlayWorld

func _ready():
	super()
	Signals.ToggleTownUI.emit(true)
