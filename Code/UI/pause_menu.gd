extends RControl

@onready var y_button = %y_button
@onready var exit_label = %exit_label
@onready var sub_menues:TabContainer = %sub_menues

var current_tab := 0:
	set(_value):
		current_tab = _value
		if current_tab >= max_tabs: current_tab = 0
		elif current_tab < 0: current_tab = max_tabs-1
		sub_menues.set_deferred("current_tab", current_tab)
		Signals.PauseMenuTabFocus.emit(current_tab)
		Signals.GrabInventoryFocus.emit()
var max_tabs := 0

func _ready():
	Signals.TogglePauseMenu.connect(_toggle_ui)
	max_tabs = sub_menues.get_tab_count()

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
	
	if is_visible() and !GM.is_playing():
		if RInput.ui_tab_left: current_tab -= 1
		elif RInput.ui_tab_right: current_tab += 1

func _toggle_ui(_value):
	if _value:
		current_tab = 0
		Signals.GrabInventoryFocus.emit(0)
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
