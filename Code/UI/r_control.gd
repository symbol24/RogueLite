class_name RControl extends Control

var ui_ready := false:
	set(_value):
		ui_ready = _value
		Signals.UiElementReady.emit()

func _toggle_ui(_value):
	if _value:show()
	else: hide()
