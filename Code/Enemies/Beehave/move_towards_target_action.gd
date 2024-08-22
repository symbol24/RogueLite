class_name MoveTowardsTargetAction extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor.target != null:
		var direciton = -1 if actor.is_target_left() else 1
		actor.velocity.x = move_toward(actor.velocity.x, actor.data.speed * direciton, 10.0/60.0)
		actor.velocity.x = clampf(actor.velocity.x, -actor.data.speed, actor.data.speed)
		actor.move_and_slide()
		if actor.get_distance_to_target() <= actor.data.attack_distance:
			return SUCCESS
	
	return RUNNING
