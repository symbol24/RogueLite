class_name Move extends RAction

func _physics_process(_delta):
	if action_available:
		r_owner.update_velocity(move(Input.get_axis("left", "right"), r_owner.velocity.x, _delta))
		r_owner.update_direction(Input.get_axis("left", "right"))
	else:
		if r_owner.velocity.x != 0: r_owner.update_velocity(0)

func move(_direction:float, _current_speed:float, _delta:float) -> float:
	#Debug.log("_direction ", _direction)
	var new_vel := _current_speed
	
	if _direction > 0.1 or _direction < -0.1:
		if r_owner.can_move and r_owner.state_machine.id == "idle":
			Signals.UpdateCharacterState.emit(r_owner, "walk")
		new_vel = move_toward(new_vel, r_owner.data.get_stat("speed") * _direction, _delta * r_owner.data.acceleration)
	else:
		if r_owner.can_move and r_owner.state_machine.id == "walk":
			Signals.UpdateCharacterState.emit(r_owner, "idle")
		new_vel = move_toward(new_vel, 0, _delta * r_owner.data.friction)

	return new_vel
