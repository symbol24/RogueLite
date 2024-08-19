extends Node

const xbox := "XInput Gamepad"
const ps3 := "PS3 Controller"
const ps4 := "PS4 Controller"
const ps5 := "PS5 Controller"
const switch := "Nintendo Switch Pro Controller"

enum TYPE {MOUSE_KEYBOARD, XBOX, PS3, PS4, PS5, SWITCH, GENERIC}
enum FOCUS {GAMEPLAY, UIFOCUS, DEBUG}

var move_left_right = 0
var move_up_down = 0
var aim_left_right = 0
var aim_up_down = 0
var jump = 0
var attack = 0
var attack_released = 0
var interact = 0
var B = 0
var B_released = 0
var start = 0
var start_released = 0
var select = 0
var LB = 0
var RB = 0
var LT = 0
var LT_released = 0
var RT = 0
var LS = 0
var RS = 0

var ui_left_stick_left_right = 0
var ui_left_stick_up_down = 0
var ui_right_stick_left_right = 0
var ui_right_stick_up_down = 0
var ui_confirm = 0
var ui_cancel = 0
var ui_cancel_released = 0
var ui_x = 0
var ui_y = 0
var ui_start = 0
var ui_start_released = 0
var ui_select = 0
var ui_tab_left = 0
var ui_tab_right = 0
var ui_sub_tab_left = 0
var ui_sub_tab_right = 0
var ui_mouse_left = 0
var ui_mouse_left_released = 0

var toggle_debug = 0

var focus := FOCUS.UIFOCUS:
	set(_value):
		previous_focus = focus
		focus = _value
		#Debug.log("Focus updated to ", _get_focus_as_string(focus))
var previous_focus := FOCUS.UIFOCUS

var allow_player_input := true :
	get: return allow_player_input
	set(value):
		_reset_values()
		allow_player_input = value

var any_input := false
var active_id := -1:
	set(_value):
		active_id = _value
var current_controls_type := TYPE.GENERIC:
	set(_value):
		current_controls_type = _value
		Signals.ControllerTypeUpdated.emit(current_controls_type)
var gamepad_type := TYPE.GENERIC

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.UpdateInputFocus.connect(_toggle_focus)
	#Signals.TogglePlayerInput.connect(_toggle_player_input)

func _process(_delta):
	match focus:
		FOCUS.GAMEPLAY:
			if GM.is_playing(): _listen_to_gameplay_inputs()
		FOCUS.UIFOCUS:
			_listen_to_ui_inputs()
		FOCUS.DEBUG:
			pass
	
	if GM.is_debug: _listen_to_debug()
	
	any_input = Input.is_anything_pressed()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouse):
		if current_controls_type != TYPE.MOUSE_KEYBOARD: current_controls_type = TYPE.MOUSE_KEYBOARD
	elif(event is InputEventJoypadButton):
		if active_id == -1 and event.device != active_id:
			_update_inputs_id(event.device)
			active_id = event.device
			_set_controller_type(Input.get_joy_name(active_id))
		if current_controls_type != gamepad_type: current_controls_type = gamepad_type

func _toggle_player_input():
	allow_player_input = !allow_player_input

func _toggle_focus(_value := FOCUS.UIFOCUS):
	_reset_values()
	focus = _value
	#if focus == FOCUS.UIFOCUS: Debug.log("In ui focus for inputs")

func _listen_to_debug():
	toggle_debug = Input.is_action_just_pressed("debug")

func _listen_to_gameplay_inputs():
	move_left_right = Input.get_axis("left", "right")
	move_up_down = Input.get_axis("up", "down")
	aim_left_right = Input.get_axis("aim_left", "aim_right")
	aim_up_down = Input.get_axis("aim_up", "aim_down")
	jump = Input.is_action_just_pressed("jump")
	attack = Input.is_action_just_pressed("attack")
	attack_released = Input.is_action_just_released("attack")
	interact = Input.is_action_just_pressed("interact")
	B = Input.is_action_just_pressed("B")
	B_released = Input.is_action_just_released("B")
	start = Input.is_action_just_pressed("start")
	start_released = Input.is_action_just_released("start")
	select = Input.is_action_just_pressed("select")
	LB = Input.is_action_just_pressed("LB")
	RB = Input.is_action_just_pressed("RB")
	LT = Input.get_action_strength("LT")
	LT_released = Input.is_action_just_released("LT")
	RT = Input.get_action_strength("RT")
	LS = Input.is_action_just_pressed("LS")
	RS = Input.is_action_just_pressed("RS")

func _listen_to_ui_inputs():
	ui_left_stick_left_right = Input.get_axis("ui_left", "ui_right")
	ui_left_stick_up_down = Input.get_axis("ui_up", "ui_down")
	ui_right_stick_left_right = Input.get_axis("ui_aim_left", "ui_aim_right")
	ui_right_stick_up_down = Input.get_axis("ui_aim_up", "ui_aim_down")
	ui_confirm = Input.is_action_just_pressed("ui_accept")
	ui_cancel = Input.is_action_just_pressed("ui_cancel")
	ui_cancel_released = Input.is_action_just_released("ui_cancel")
	ui_start = Input.is_action_just_pressed("ui_start")
	ui_start_released = Input.is_action_just_released("ui_start")
	ui_select = Input.is_action_just_pressed("ui_select")
	ui_tab_left = Input.is_action_just_pressed("ui_tab_left")
	ui_tab_right = Input.is_action_just_pressed("ui_tab_right")
	ui_sub_tab_left = Input.is_action_just_pressed("ui_sub_tab_left")
	ui_sub_tab_right = Input.is_action_just_pressed("ui_sub_tab_right")
	ui_y = Input.is_action_just_pressed("ui_y")
	ui_x = Input.is_action_just_pressed("ui_x")
	ui_mouse_left = Input.is_action_just_pressed("ui_mouse_left")
	ui_mouse_left_released = Input.is_action_just_released("ui_mouse_left")

func _reset_values():
	move_left_right = 0
	move_up_down = 0
	aim_left_right = 0
	aim_up_down = 0
	jump = 0
	attack = 0
	attack_released = 0
	interact = 0
	B = 0
	B_released = 0
	start = 0
	start_released = 0
	select = 0
	LB = 0
	RB = 0
	LT = 0
	LT_released = 0
	RT = 0
	LS = 0
	RS = 0

	ui_left_stick_left_right = 0
	ui_left_stick_up_down = 0
	ui_right_stick_left_right = 0
	ui_right_stick_up_down = 0
	ui_confirm = 0
	ui_cancel = 0
	ui_cancel_released = 0
	ui_x = 0
	ui_y = 0
	ui_start = 0
	ui_start_released = 0
	ui_select = 0
	ui_tab_left = 0
	ui_tab_right = 0
	ui_sub_tab_left = 0
	ui_sub_tab_right = 0
	ui_mouse_left = 0
	ui_mouse_left_released = 0
	
	toggle_debug = 0

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
