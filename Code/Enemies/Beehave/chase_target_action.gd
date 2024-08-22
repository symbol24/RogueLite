class_name ChaseTargetAction extends ActionLeaf

var anim_played := false

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !anim_played:
		actor.chase()
		anim_played = true
	
	if actor.target != null and actor.get_distance_to_target() <= actor.data.attack_distance:
		actor.set_state(REnemy.STATE.ATTACK)
		anim_played = false
		return SUCCESS
	elif actor.target != null and actor.get_distance_to_target() > actor.data.chase_distance * 2:
		actor.set_state(REnemy.STATE.IDLE)
		anim_played = false
		return SUCCESS
	
	return RUNNING
