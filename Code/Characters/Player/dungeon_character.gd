class_name DungeonCharater extends RCharacter

@onready var camera_remote:RRemoteTransform2D = %camera_remote

func _ready():
	Signals.DebugToggleGodMode.connect(_toggle_god_mode)
	Signals.DebugCharacterHit.connect(_debug_character_hit)
	Signals.DebugAddMaxHP.connect(_debug_update_max_hp)
	Signals.StateUpdated.connect(_update_animation_from_state)
	Signals.UpdateCharacterState.emit(self, "idle")
	Signals.StartAttack.connect(_start_attack)
	#Debug.log(character_data)
	data = character_data.duplicate()
	data.setup_data()
	for child in get_children(true):
		if child.is_in_group("flip"):
			items_to_flip.append(child)
	if animator.is_node_ready():
		Signals.CharacterReady.emit(self)

func _emit_signal(_id := "", _opt1 := "", _opt2 := ""):
	match _id:
		"end_land":
			Signals.UpdateCharacterState.emit(self, "idle")
		"toggle_attack":
			if _opt1 and _opt2:
				var is_enabled := false
				if _opt2 == "true": is_enabled = true
				Signals.ToggleAttackCollier.emit(_opt1, is_enabled)
		"attack_ended":
			if _opt1:
				Signals.AttackEnded.emit(self, _opt1)

func _start_attack(_character:RCharacter, _name := ""):
	#Debug.log("Receiving ", _character.name, " and ", _name)
	if _character == self and _name:
		_update_animation(_name)
		Signals.UpdateCharacterState.emit(self, "attack")

func _character_hit(_dmgs:Array[Damage] = []):
	if !_dmgs.is_empty():
		for dmg in _dmgs:
			data.apply_damage(dmg)
