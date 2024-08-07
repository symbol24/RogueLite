extends RDungeonUiElement

func _ready():
	super()
	Signals.ToggleEndRunMenu.connect(_toggle_ui)
	ui_ready = true
	
func _process(_delta):
	if RInput.ui_cancel:
		Debug.log("pressed cancel")
		Signals.LoadNewWorld.emit("test_town")
