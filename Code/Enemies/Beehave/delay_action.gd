class_name DelayAction extends ActionLeaf

@export var delay_id := ""
@export var delay_in_seconds := 0.0

var active := true
var timer := 0.0

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if !_blackboard.has_value(delay_id):
		_blackboard.set_value(delay_id, true)
		timer += 1
	else:
		if _blackboard.get_value(delay_id):
			timer += 1
			if timer / 60 >= delay_in_seconds:
				_blackboard.set_value(delay_id, false)
				return SUCCESS

	if !_blackboard.get_value(delay_id): return SUCCESS
	
	return RUNNING
