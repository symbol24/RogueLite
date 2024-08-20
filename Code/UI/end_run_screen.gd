extends RDungeonUiElement

func _ready():
	super()
	Signals.ToggleEndRunMenu.connect(_toggle_ui)
	ui_ready = true

func _input(event: InputEvent) -> void:
	if is_visible() and event.is_action_pressed("ui_cancel"):
		#Debug.log("pressed cancel")
		_toggle_ui(false)
		Signals.LoadNewWorld.emit("test_town")
