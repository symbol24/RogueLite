class_name ProduceInteractableData extends InteractableData

@export var loot_table:LootTable
@export var loot_amount := {"min":1, "max":3}

var amount:
	get:
		return GM.rng.randi_range(loot_amount["min"], loot_amount["max"])
