class_name SetAnimationAction extends ActionLeaf

@export var animation := ""

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !actor.is_animation_playing(animation):
		actor.set_animation(animation)
		_blackboard.set_value("current_animation", animation)
	return SUCCESS
