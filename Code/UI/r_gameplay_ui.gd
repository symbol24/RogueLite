class_name RGameplayControl extends RControl

var children_count := 0
var children_ready := 0

func _ready():
	children_count = get_child_count(false)

func _check_all_children_ready():
	if children_count == children_ready:
		Signals.UIReady.emit()
