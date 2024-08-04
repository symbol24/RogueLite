extends RControl

func _ready():
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)
	
func _toggle_loading_screen(_value := false):
	if _value:show()
	else: hide()