extends Node

const xbox := "XInput Gamepad"
const ps3 := "PS3 Controller"
const ps4 := "PS4 Controller"
const ps5 := "PS5 Controller"
const switch := "Nintendo Switch Pro Controller"

enum TYPE {MOUSE_KEYBOARD, XBOX, PS3, PS4, PS5, SWITCH, GENERIC}
enum FOCUS {GAMEPLAY, UIFOCUS, DEBUG}

#Input focus stuff
var focus := FOCUS.UIFOCUS:
	set(_value):
		previous_focus = focus
		focus = _value
		#Debug.log("Focus updated to ", _get_focus_as_string(focus))
var previous_focus := FOCUS.UIFOCUS
var is_focused_on_ui:bool:
	get:
		return focus == FOCUS.UIFOCUS
var is_focused_on_gameplay:bool:
	get:
		return focus == FOCUS.GAMEPLAY

#GAMEPAD STUFF
var active_id := -1:
	set(_value):
		active_id = _value
var current_controls_type := TYPE.GENERIC:
	set(_value):
		current_controls_type = _value
		Signals.ControllerTypeUpdated.emit(current_controls_type)
var gamepad_type := TYPE.GENERIC

#Mouse cursor stuff
var confined := false
var active_delay := false
var hide_mouse_delay := 2.0
var hide_mouse_timer := 0.0:
	set(_value):
		hide_mouse_timer = _value
		if hide_mouse_timer >= hide_mouse_delay:
			hide_mouse_timer = 0.0
			if confined: Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

#other stuff
var any_input := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.UpdateInputFocus.connect(_toggle_focus)

func _physics_process(_delta: float) -> void:
	if active_delay:
		hide_mouse_timer += _delta

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouse):
		if current_controls_type != TYPE.MOUSE_KEYBOARD: current_controls_type = TYPE.MOUSE_KEYBOARD
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN or Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN:
			if confined: Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_start_mouse_timer()
	elif(event is InputEventJoypadButton):
		if active_id == -1 and event.device != active_id:
			_update_inputs_id(event.device)
			active_id = event.device
			_set_controller_type(Input.get_joy_name(active_id))
		if current_controls_type != gamepad_type: current_controls_type = gamepad_type

func _start_mouse_timer():
	if active_delay and hide_mouse_timer != 0.0:
		hide_mouse_timer = 0.0
	elif !active_delay:
		active_delay = true

func _toggle_focus(_value := FOCUS.UIFOCUS):
	focus = _value

func _get_focus_as_string(_focus:FOCUS) -> String:
	match _focus:
		FOCUS.GAMEPLAY:
			return "GAMEPLAY"
		FOCUS.UIFOCUS:
			return "UIFOCUS"
		FOCUS.DEBUG:
			return "DEBUG"
		_:
			return "not in focus list?"

func _set_active_controller_id(_id := 0) -> void:
	active_id = _id

func _update_inputs_id(_id := 0) -> void:
	for action in InputMap.get_actions():
		for event in InputMap.action_get_events(action):
			if event.device != _id: event.device = _id

func _set_controller_type(_controller_name:="") -> void:
	var controller_type := TYPE.GENERIC
	match _controller_name:
		xbox:
			controller_type = TYPE.XBOX
		ps3:
			controller_type = TYPE.PS3
		ps4:
			controller_type = TYPE.PS4
		ps5:
			controller_type = TYPE.PS5
		switch:
			controller_type = TYPE.SWITCH
		_:pass
		
	if current_controls_type != controller_type: 
		current_controls_type = controller_type
		gamepad_type = controller_type
