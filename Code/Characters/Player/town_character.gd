class_name TownCharacter extends RCharacter

@onready var camera_remote:RRemoteTransform2D = %camera_remote
@onready var state_machine:RStateMachine = %state_machine

func _ready():
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	data = character_data.duplicate()
	data.setup_data()
	if animator.is_node_ready():
		items_to_flip = _get_flip(self)
		Signals.CharacterReady.emit(self)
		Signals.UpdateAllCurrencies.emit()

func _physics_process(_delta):
	if GM.is_playing():
		grounded = is_on_floor_only()
		if !grounded: _apply_gravity(_delta)
		
		if _get_can_move():
			move_and_slide()
		
		if state_machine.can_flip:
			_flip_items(items_to_flip, direction, sprite)

func _get_can_move() -> bool:
	if state_machine:
		return state_machine.can_move
	return false
