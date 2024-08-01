extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

#R Character
signal CharacterGrounded(character)

#Actions
signal StartAttack(character, attack_name)
signal AttackEnded(character, attack_name)
signal ToggleAttackCollier(attack_name, is_enabled)

#main characters state machine
signal StateUpdated(character, state)
signal UpdateCharacterState(character, state_id)

#UI
signal UpdateInputFocus(focus)

#Debug
signal DebugPrint(text)
signal DebugError(text)
signal DebugWarning(text)
signal DebugToggleGodMode()
