class_name RTown extends RPlayWorld

func _ready():
	Signals.ToggleTownUI.emit(true)
	super()
