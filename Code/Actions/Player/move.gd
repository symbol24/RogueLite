class_name Move extends RAction

func _physics_process(_delta):
	r_owner.update_velocity(move(RInput.move_left_right, r_owner.velocity.x, _delta))
	r_owner.update_direction(RInput.move_left_right)

func move(_direction:float, _current_speed:float, _delta:float) -> float:
	var new_vel := _current_speed
	
	if _direction > 0.1 or _direction < -0.1:
		if r_owner.can_move and r_owner.state_machine.id == "idle":
			Signals.UpdateCharacterState.emit(r_owner, "walk")
		new_vel = move_toward(new_vel, r_owner.data.speed * _direction, _delta * r_owner.data.acceleration)
	else:
		if r_owner.can_move and r_owner.state_machine.id == "walk":
			Signals.UpdateCharacterState.emit(r_owner, "idle")
		new_vel = move_toward(new_vel, 0, _delta * r_owner.data.friction)

	new_vel = clampf(new_vel, -r_owner.data.speed, r_owner.data.speed)

	return new_vel
