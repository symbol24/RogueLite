class_name DungeonLootTable extends LootTable

@export var currencies:Array = [{"currency": preload("res://Data/Items/Currencies/gold_data.tres"), "min":1, "max":3}]

func get_currencies() -> Array:
	var result = []
	for each in currencies:
		var new = {"currency":each["currency"], "amount":GM.rng.randi_range(each["min"], each["max"])}
		result.append(new)
	return result
