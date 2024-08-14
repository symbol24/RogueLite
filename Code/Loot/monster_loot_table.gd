class_name MonsterLootTable extends LootTable

@export var currencies:Array = [{"currency": GM.CURRENCIES.GOLD, "min":1, "max":3}]

func get_currencies() -> Array:
	var result = []
	for each in currencies:
		var new = {"currency":each["currency"], "amount":GM.rng.randi_range(each["min"], each["max"])}
		result.append(new)
	return result
