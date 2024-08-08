extends RControl

@onready var y_button = %y_button
@onready var exit_label = %exit_label

func _ready():
	Signals.TogglePauseMenu.connect(_toggle_ui)

func _process(_delta):
	if !is_visible() and GM.is_playing() and RInput.start:
		Signals.UpdateInputFocus.emit(RInput.FOCUS.UIFOCUS)
		Signals.TogglePause.emit(true)
		
	if is_visible() and !GM.is_playing() and (RInput.ui_cancel or RInput.ui_start):
		Signals.UpdateInputFocus.emit(RInput.FOCUS.GAMEPLAY)
		Signals.TogglePause.emit(false)
		
	if is_visible() and !GM.is_playing() and GM.world is RDungeon and RInput.ui_y:
		_toggle_ui(false)
		if GM.world is RDungeon:
			Signals.LoadNewWorld.emit("test_town")

func _toggle_ui(_value):
	if _value:
		show()
		if GM.world is RDungeon: _toggle_exit(true)
		else: _toggle_exit(false)
	else: hide()

func _toggle_exit(_value := false):
	if _value:
		y_button.show()
		exit_label.show()
	else:
		y_button.hide()
		exit_label.hide()
