extends Node

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

#Generic
signal ClassReady(_name)
signal UpdateInputFocus(focus)

#Player Data
signal Save()
signal Load()
signal DeleteSave()
signal UpdateAllCurrencies()

#GameManger
signal LoadNewWorld(id)
signal LoadBuilding(path, entrance)
signal ExitBuilding(building)
signal CharacterSet(data)
signal WorldSet(world)
signal TogglePause(value)
signal ToggleEndRun(value)
signal EndRunCheck()
signal ItemManagerIsSet(manager)

#Worlds
signal WorldReady(world)
signal SetItemManager(item_manager)

#R Character
signal CharacterReady(character)
signal CharacterGrounded(character)
signal HPUpdated(character, difference)
signal MaxHPUpdated(character, new_max_hp)
signal CharacterDead(character)
signal CharacterNoMoreLives(character)
signal AttackReceived(target, damages)
signal ToggleHitCollider(_owner, disabled)

#Actions
signal StartAttack(character, attack_name)
signal AttackEnded(character, attack_name)
signal ToggleAttackCollider(attack_name, is_enabled)

#main characters state machine
signal StateUpdated(character, state)
signal UpdateCharacterState(character, state_id)

#inventory
signal AddItem(item)
signal AdditemToInventoryUi(dict)
signal UpdateCountOfitemInUi(dict)
signal InventoryFull(error_id)

#loot
signal Collect(target, item, amount)
signal SpawnLoot(loot_table, _position)

#UI
signal UiFocusUpdated(id)
signal ToggleUiFocus(id)
signal ToggleDungeonUI(value)
signal ToggleTownUI(value)
signal ToggleLoadingScreen(value)
signal UIReady()
signal UiElementReady()
signal TogglePauseMenu(value)
signal ToggleEndRunMenu(value)
signal DmgNmbRepool(dmgnumber)
signal DisplayDmgNumber(value, damage_type, is_critical, marker2D)
signal GrabInventoryFocus(tab)
signal InventoryPagesDone()
signal PauseMenuTabFocus(tab)
signal ActiveInventorySquare(slot)
signal MoveItemToNewParent(item, slot_id)
signal SetHoverOnSquare(slot_id)
signal RemoveHoverOnSquare(slot_id)
signal PauseMenuInventoryToggleDot(id)

#Error management
signal DisplayError(id)
signal DisplayPopup(id, type)
signal PopupCancelled(id)
signal ConfirmPopup(id)

#Debug
signal DebugPrint(text)
signal DebugError(text)
signal DebugWarning(text)
signal DebugToggleGodMode()
signal DebugCharacterHit(damage)
signal DebugAddMaxHP(value)
signal DebugEndRun(value)
signal DebugAddRandomItem()
