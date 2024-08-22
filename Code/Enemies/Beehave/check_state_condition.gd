class_name CheckStateCondition extends ConditionLeaf

@export var state_to_check := REnemy.STATE.IDLE

func tick(actor: Node, _blackboard: Blackboard) -> int:
	#Debug.log("Checking state for ", state_to_check)
	if actor.state == state_to_check:
		return SUCCESS
	return FAILURE
