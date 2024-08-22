class_name CheclAnimationEnd extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	Debug.log("current animation: ", _blackboard.get_value("current_animation"))
	if actor.is_animation_over(_blackboard.get_value("current_animation")):
		_blackboard.set_value("current_animation", "")
		return SUCCESS
	return RUNNING
