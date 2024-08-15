class_name SubPauseMenu extends RControl

@export var tab_name := ""
@export var tab_id := -1

func _ready():
	super()
	Signals.PauseMenuTabFocus.connect(_check_in_focus)

func _check_in_focus(_tab := -1):
	if tab_id == -1: Debug.log("Pause Menu Sub Menu ", tab_name, " does not have an id assigned.")
	if _tab == tab_id: in_focus = true
	else: in_focus = false
