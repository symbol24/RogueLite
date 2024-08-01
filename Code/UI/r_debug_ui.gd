class_name DebugUI extends Control

@onready var display_label:RichTextLabel = %display_label
@onready var input_line:LineEdit = %input_line

var active := false
var lines:Array[String] = []

func _ready():
	active = GM.is_debug
	input_line.text_submitted.connect(_parse_test)
	Signals.DebugPrint.connect(_debug_print)
	Signals.DebugError.connect(_debug_error)
	Signals.DebugWarning.connect(_debug_warning)

func _process(_delta):
	if GM.is_debug:
		if RInput.toggle_debug:
			_toggle_display()

func _toggle_display():
	if !visible:
		Signals.UpdateInputFocus.emit(RInput.FOCUS.DEBUG)
		input_line.text = ""
		input_line.grab_focus()
		show()
	else: hide()

func _parse_test(_value:= ""):
	if _value:
		_debug_print(_value)
		lines.append(_value)
		var split = _value.split(" ", false, 20)
		Debug.do_command(split)
	input_line.text = ""

func _display_text(_value:Array[String] = []):
	display_label.text += "\n"
	var x := 1
	for word in _value:
		display_label.text += word
		if x < _value.size(): display_label.text += " "

func _debug_print(_to_print := ""):
	print(_to_print)
	_display_text([_to_print])

func _debug_error(_to_print := ""):
	printerr(_to_print)
	_display_text(["[color=indian_red]• ", _to_print, "[/color]"])

func _debug_warning(_to_print := ""):
	print_rich("[color=khaki]- " + _to_print + "[/color]")
	_display_text(["[color=khaki]- ", _to_print, "[/color]"])
