extends Node

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
var start = 0
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
var ui_x = 0
var ui_y = 0
var ui_start = 0
var ui_select = 0
var ui_tab_left = 0
var ui_tab_right = 0

var toggle_debug = 0

var focus := FOCUS.UIFOCUS:
	set(_value):
		focus = _value
		#Debug.log("Focus updated to ", _get_focus_as_string(focus))
var focused_on_ui := false
var focused_on_debug := false
var allow_player_input := true :
	get: return allow_player_input
	set(value):
		_reset_values()
		allow_player_input = value

var any_input := false

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

func _toggle_player_input():
	allow_player_input = !allow_player_input

func _toggle_focus(_value := FOCUS.UIFOCUS):
	_reset_values()
	focus = _value

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
	start = Input.is_action_just_pressed("start")
	select = Input.is_action_just_pressed("select")
	LB = Input.is_action_just_pressed("LB")
	RB = Input.get_action_strength("RB")
	LT = Input.is_action_just_pressed("LT")
	LT_released = Input.is_action_just_released("LT")
	RT = Input.get_action_strength("RT")
	LS = Input.get_action_strength("LS")
	RS = Input.get_action_strength("RS")

func _listen_to_ui_inputs():
	ui_left_stick_left_right = Input.get_axis("ui_left", "ui_right")
	ui_left_stick_up_down = Input.get_axis("ui_up", "ui_down")
	ui_right_stick_left_right = Input.get_axis("ui_aim_left", "ui_aim_right")
	ui_right_stick_up_down = Input.get_axis("ui_aim_up", "ui_aim_down")
	ui_confirm = Input.is_action_just_pressed("ui_accept")
	ui_cancel = Input.is_action_just_pressed("ui_cancel")
	ui_start = Input.is_action_just_pressed("ui_start")
	ui_select = Input.is_action_just_pressed("ui_select")
	ui_tab_left = Input.get_action_strength("ui_tab_left")
	ui_tab_right = Input.get_action_strength("ui_tab_right")
	ui_y = Input.get_action_strength("ui_y")
	ui_x = Input.get_action_strength("ui_x")

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
	start = 0
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
	ui_x = 0
	ui_y = 0
	ui_start = 0
	ui_select = 0
	
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
