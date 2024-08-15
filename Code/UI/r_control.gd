class_name RControl extends Control

var id := 0
var ui_ready := false:
	set(_value):
		ui_ready = _value
		Signals.UiElementReady.emit()

var in_focus := false:
	set(_value):
		in_focus = _value
		if in_focus: Signals.UiFocusUpdated.emit(id)

func _ready() -> void:
	id = hash(name)
	Signals.ToggleUiFocus.connect(_toggle_focus)

func _toggle_ui(_value):
	if _value:show()
	else: hide()

func _toggle_focus(_id := 0):
	if _id == id: in_focus = true
	else: in_focus = false
