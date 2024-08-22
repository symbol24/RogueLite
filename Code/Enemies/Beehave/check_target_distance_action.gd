class_name CheckTargetDistanceAction extends ActionLeaf

enum TYPE {BOTH, CLOSE, FAR}

@export var check_distance := TYPE.BOTH

var timer := 0
var delay := 90 #60 ticks = 1 second?

func tick(actor: Node, _blackboard: Blackboard) -> int:
	timer += 1
	if timer >= delay:
		timer = 0
		#Debug.log("actor.target: ", actor.target, " and distance: ", actor.get_distance_to_target())
		if check_distance in [TYPE.BOTH, TYPE.CLOSE] and actor.target != null and actor.get_distance_to_target() <= actor.data.attack_distance:
			actor.set_state(REnemy.STATE.ATTACK)
			return SUCCESS
		elif check_distance in [TYPE.BOTH, TYPE.FAR] and actor.target != null and actor.get_distance_to_target() <= actor.data.chase_distance:
			actor.set_state(REnemy.STATE.CHASE)
			return SUCCESS

	return RUNNING
