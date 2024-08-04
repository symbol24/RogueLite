extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

#Generic
signal ClassReady(_name)

#GameManger
signal LoadNewWorld(id)
signal CharacterSet(data)
signal WorldSet(world)
signal TogglePause(value)

#Worlds
signal WorldReady(world)

#R Character
signal CharacterReady(character)
signal CharacterGrounded(character)
signal HPUpdated(character, difference)
signal MaxHPUpdated(character, new_max_hp)
signal CharacterDead(character)
signal CharacterNoMoreLive(character)

#Actions
signal StartAttack(character, attack_name)
signal AttackEnded(character, attack_name)
signal ToggleAttackCollier(attack_name, is_enabled)

#main characters state machine
signal StateUpdated(character, state)
signal UpdateCharacterState(character, state_id)

#UI
signal UpdateInputFocus(focus)
signal ToggleDungeonUI(value)
signal ToggleTownUI(value)
signal ToggleLoadingScreen(value)
signal UIReady()
signal HPBarSetupDone()
signal TogglePauseMenu(value)

#Debug
signal DebugPrint(text)
signal DebugError(text)
signal DebugWarning(text)
signal DebugToggleGodMode()
signal DebugCharacterHit(damage)
signal DebugAddMaxHP(value)
