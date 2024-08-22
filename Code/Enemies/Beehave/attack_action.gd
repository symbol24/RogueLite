class_name AttackAction extends ActionLeaf

@export var attack_animation := ""

var anim_played := false

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if !anim_played:
		actor.attack(attack_animation)
		anim_played = true
	
	if actor.is_animation_over(attack_animation):
		actor.set_state(REnemy.STATE.IDLE)
		anim_played = false
		return SUCCESS
	return RUNNING
