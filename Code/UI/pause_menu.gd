extends RControl

func _ready():
	Signals.TogglePauseMenu.connect(_toggle_ui)

func _process(_delta):
	if GM.is_playing() and RInput.start:
		Signals.UpdateInputFocus.emit(RInput.FOCUS.UIFOCUS)
		Signals.TogglePause.emit(true)
		
	if !GM.is_playing() and (RInput.ui_cancel or RInput.ui_start):
		Signals.UpdateInputFocus.emit(RInput.FOCUS.GAMEPLAY)
		Signals.TogglePause.emit(false)

func _toggle_ui(_value):
	if _value:show()
	else: hide()
