class_name DebugUI extends RControl

@onready var display_label:RichTextLabel = %display_label
@onready var input_line:LineEdit = %input_line

var active := false
var lines:Array[String] = []
var prev_focus := RInput.FOCUS.GAMEPLAY

func _ready() -> void:
	super()
	process_mode = Node.PROCESS_MODE_ALWAYS
	active = GM.is_debug
	input_line.text_submitted.connect(_parse_test)
	Signals.DebugPrint.connect(_debug_print)
	Signals.DebugError.connect(_debug_error)
	Signals.DebugWarning.connect(_debug_warning)

func _input(event: InputEvent) -> void:
	if GM.is_debug and event.is_action_pressed("debug"):
		_toggle_display()

func _toggle_display() -> void:
	if !is_visible():
		prev_focus = RInput.focus
		Signals.UpdateInputFocus.emit(RInput.FOCUS.DEBUG)
		show()
		input_line.text = ""
		input_line.grab_focus()
	else: 
		Signals.UpdateInputFocus.emit(prev_focus)
		hide()
		input_line.text = ""

func _parse_test(_value:= "") -> void:
	if _value:
		_debug_print(_value)
		lines.append(_value)
		var split = _value.split(" ", false, 20)
		Debug.do_command(split)
	input_line.text = ""

func _display_text(_value:Array[String] = []) -> void:
	display_label.text += "\n"
	var x := 1
	for word in _value:
		display_label.text += word
		if x < _value.size(): display_label.text += " "

func _debug_print(_to_print := "") -> void:
	print(_to_print)
	_display_text([_to_print])

func _debug_error(_to_print := "") -> void:
	printerr(_to_print)
	_display_text(["[color=indian_red]• ", _to_print, "[/color]"])

func _debug_warning(_to_print := "") -> void:
	print_rich("[color=khaki]- " + _to_print + "[/color]")
	_display_text(["[color=khaki]- ", _to_print, "[/color]"])
