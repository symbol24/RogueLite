class_name LookAtTarget extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !actor.flipped and actor.is_target_left():
		actor.flip()
		return SUCCESS
	elif actor.flipped and !actor.is_target_left():
		actor.flip()
		return SUCCESS
	return RUNNING
