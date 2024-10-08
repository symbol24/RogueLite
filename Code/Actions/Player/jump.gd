class_name Jump extends RAction

var jump_count := 0
var max_jump_count := 0
var landed := false
var coyote_delay := 0.3
var coyote_timer := 0.0

func _ready() -> void:
	super._ready()
	Signals.CharacterGrounded.connect(_set_landed)

func _input(event: InputEvent) -> void:
	if action_available and event.is_action_pressed("jump"):
		jump()

func _physics_process(_delta):
	if action_available:
		if max_jump_count == 0 and r_owner.data:
			max_jump_count = r_owner.data.jump_count
			jump_count = r_owner.data.jump_count
			
		_check_falling(r_owner.velocity.y)
		_coyote_time(_delta)

func jump() -> void:
	if jump_count > 0:
		#Debug.log("Jump count: ", jump_count)
		landed = false
		jump_count -= 1
		r_owner.velocity.y = r_owner.get_jump_velocity()
		Signals.UpdateCharacterState.emit(r_owner, "jump")
		
func _set_landed(_character:RCharacter):
	if _character == r_owner and !landed and _character.grounded:
		landed = true
		if _character.last_y > 300.0:
			Signals.UpdateCharacterState.emit(r_owner, "hard_land")
		else:
			Signals.UpdateCharacterState.emit(r_owner, "idle")
		if r_owner.data is MainCharacterData and r_owner.data: jump_count = r_owner.data.jump_count
		else: jump_count = 1
		coyote_timer = 0.0
		can_action = true

func _check_falling(_y := 0.0):
	if !landed and _y > 50.0:
		Signals.UpdateCharacterState.emit(r_owner, "fall")

func _coyote_time(_delta := 0.0):
	if !landed:
		coyote_timer += _delta
		if coyote_timer >= coyote_delay:
			if jump_count == r_owner.data.jump_count: jump_count -= 1
