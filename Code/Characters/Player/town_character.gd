class_name TownCharacter extends RCharacter

@onready var camera_remote:RRemoteTransform2D = %camera_remote

func _ready():
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	data = character_data.duplicate()
	data.setup_data()
	for child in get_children(true):
		if child.is_in_group("flip"):
			items_to_flip.append(child)
	if animator.is_node_ready():
		Signals.CharacterReady.emit(self)
