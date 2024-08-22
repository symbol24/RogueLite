class_name DelayResetAction extends ActionLeaf

@export var delay_id := ""

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if _blackboard.has_value(delay_id):
		_blackboard.set_value(delay_id, true)
		return SUCCESS
	
	Debug.warning(_actor.data.id, "'s blackboard does not contain a value for ", delay_id)
	return FAILURE
