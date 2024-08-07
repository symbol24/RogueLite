class_name RGameplayControl extends RControl

var children_count := 0
var children_ready := 0

func _ready():
	children_count = get_child_count(false)

func _check_all_children_ready():
	#Debug.log("children_count == _get_ready_ui_elements() ", children_count, " == ", _get_ready_ui_elements())
	if children_count == _get_ready_ui_elements():
		Signals.UIReady.emit()

func _get_ready_ui_elements() -> int:
	var i = 0
	for element in get_children(false):
		#Debug.log("element ", element.name, " has ui_ready? ", element.get("ui_ready"))
		if element.get("ui_ready"):
			if element.ui_ready: i += 1
	
	return i
