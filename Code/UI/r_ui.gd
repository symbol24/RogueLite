extends RCanvasLayer

@export var gamepad_cross_mapping: GamepadIconData

var current_focus := 0:
	set(_value):
		previous_focus = current_focus
		current_focus = _value
var previous_focus := 0

func _ready() -> void:
	Signals.UiFocusUpdated.connect(_set_focus_id)

func _set_focus_id(_value := 0) -> void:
	current_focus = _value

func get_icon(_type := RInput.TYPE.GENERIC, _name := "") -> Node2D:
	var to_return = null
	for each in gamepad_cross_mapping.map:
		if each["id"] == _name:
			match _type:
				RInput.TYPE.XBOX:
					to_return = each["xbox"]
				RInput.TYPE.PS3:
					to_return = each["ps"]
				RInput.TYPE.PS4:
					to_return = each["ps"]
				RInput.TYPE.PS5:
					to_return = each["ps"]
				RInput.TYPE.SWITCH:
					to_return = each["switch"]
				_:
					pass
	
	if to_return != null:
		return to_return.instantiate()
	
	Debug.error("no icon found for ", _name, " in ", _type)
	return null
