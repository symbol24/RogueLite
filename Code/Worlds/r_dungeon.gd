class_name RDungeon extends RPlayWorld

const LOOT_MANAGER = preload("res://Scenes/Loot/loot_manager.tscn")

func _ready() -> void:
	_setup_loot_manager(LOOT_MANAGER)
	Signals.ToggleDungeonUI.emit(true)
	super()
	
func _setup_loot_manager(_preload):
	if _preload != null:
		var new = _preload.instantiate() as LootManager
		add_child.call_deferred(new)
