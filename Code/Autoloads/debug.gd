extends Node

var commands:Array[String] = [
							"!help",
							"!godmode"
							]

func stringify(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = "") -> String:
	var total := ""
	if _value1: total += str(_value1)
	if _value2: total += str(_value2)
	if _value3: total += str(_value3)
	if _value4: total += str(_value4)
	if _value5: total += str(_value5)
	if _value6: total += str(_value6)
	if _value7: total += str(_value7)
	if _value8: total += str(_value8)
	if _value9: total += str(_value9)
	if _value10: total += str(_value10)
	if _value11: total += str(_value11)
	if _value12: total += str(_value12)
	if _value13: total += str(_value13)
	if _value14: total += str(_value14)
	if _value15: total += str(_value15)
	if _value16: total += str(_value16)
	if _value17: total += str(_value17)
	if _value18: total += str(_value18)
	if _value19: total += str(_value19)
	if _value20: total += str(_value20)
	return total

func log(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	Signals.DebugPrint.emit(text)

func error(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	Signals.DebugError.emit(text)
	
func warning(_value1 = "", _value2 = "", _value3 = "", _value4 = "", _value5 = "", _value6 = "", _value7 = "", _value8 = "", _value9 = "", _value10 = "", _value11 = "", _value12 = "", _value13 = "", _value14 = "", _value15 = "", _value16 = "", _value17 = "", _value18 = "", _value19 = "", _value20 = ""):
	var text = stringify(_value1, _value2, _value3, _value4, _value5, _value6, _value7, _value8, _value9, _value10, _value11, _value12, _value13, _value14, _value15, _value16, _value17, _value18, _value19, _value20)
	Signals.DebugWarning.emit(text)

func do_command(_inputs:Array[String] = []):
	var command = _inputs.pop_front()
	match command:
		"!help":
			var text:=""
			for each in commands:
				text += each + " "
			Debug.log(text)
		"!godmode":
			Signals.DebugToggleGodMode.emit()
			Debug.log("Godmode toggled")
		_:
			Debug.log("Command unrecognized")
