class_name ButtonSwapper extends RControl

@onready var gamepad: Control = %gamepad
@onready var button: Control = %button

@export var data:ButtonData

var xbox
var ps
var switch
var kbm

func _ready() -> void:
	Signals.ControllerTypeUpdated.connect(_display_icon)
	_load_icons()
	
func _load_icons() -> void:
	if data != null:
		var action_id = PlayerData.get_button_for(data.action)
		xbox = UI.get_icon(RInput.TYPE.XBOX, action_id)
		gamepad.add_child.call_deferred(xbox)
		xbox.hide()
		ps = UI.get_icon(RInput.TYPE.PS5, action_id)
		gamepad.add_child.call_deferred(ps)
		ps.hide()
		switch = UI.get_icon(RInput.TYPE.SWITCH, action_id)
		gamepad.add_child.call_deferred(switch)
		switch.hide()
	 
func _display_icon(_type:=RInput.TYPE.GENERIC) -> void:
	if _type in [RInput.TYPE.XBOX, RInput.TYPE.PS3, RInput.TYPE.PS4, RInput.TYPE.PS5, RInput.TYPE.SWITCH]:
			button.hide()
			gamepad.show()
			xbox.hide()
			ps.hide()
			switch.hide()
			
	match _type:
		RInput.TYPE.GENERIC:
			xbox.show()
		RInput.TYPE.XBOX:
			xbox.show()
		RInput.TYPE.PS3:
			ps.show()
		RInput.TYPE.PS4:
			ps.show()
		RInput.TYPE.PS5:
			ps.show()
		RInput.TYPE.SWITCH:
			switch.show()
		RInput.TYPE.MOUSE_KEYBOARD:
			button.show()
			gamepad.hide()
