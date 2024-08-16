class_name DungeonInteractableData extends InteractableData

@export var loot_amount_dict := {"min":1, "max": 5}
	

@export var loot_table:LootTable

var loot_amount:
	get:
		return GM.rng.randi_range(loot_amount_dict["min"], loot_amount_dict["max"])
