class_name IdleAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	#Debug.log("idle")
	actor.idle()
	return SUCCESS
