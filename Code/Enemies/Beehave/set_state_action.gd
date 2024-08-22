class_name SetStateAction extends ActionLeaf

@export var state_to_set := REnemy.STATE.IDLE

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.state != state_to_set:
		actor.set_state(state_to_set)
		return SUCCESS
	return FAILURE
