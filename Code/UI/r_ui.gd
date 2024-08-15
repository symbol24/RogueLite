extends RCanvasLayer

var current_focus := 0:
	set(_value):
		previous_focus = current_focus
		current_focus = _value
var previous_focus := 0

func _ready() -> void:
	Signals.UiFocusUpdated.connect(_set_focus_id)

func _set_focus_id(_value := 0) -> void:
	current_focus = _value
