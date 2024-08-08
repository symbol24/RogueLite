extends RDungeonUiElement

func _ready():
	super()
	Signals.ToggleEndRunMenu.connect(_toggle_ui)
	ui_ready = true
	
func _process(_delta):
	if is_visible() and RInput.ui_cancel:
		#Debug.log("pressed cancel")
		_toggle_ui(false)
		Signals.LoadNewWorld.emit("test_town")
 
