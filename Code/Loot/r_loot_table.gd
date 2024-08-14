class_name LootTable extends Resource

@export var id := ""
##Each item should have a "weight" as int and an "item" as data
@export var list:Array[Array]


func get_loot() -> Array:
	var result := []
	var temp = list.duplicate(true)
	for table in temp:
		var total := 0
		for item in table:
			if item.has("weight") and item["weight"] is int:
				total += item["weight"]
				item["weight"] = total
		var c = randi_range(0,3)
		var i = 0
		while i < c:
			temp.shuffle()
			i+=1
		var weight = GM.rng.randi_range(0, total)
		var found := false
		for item in table:
			if !found and item.has("weight") and item["weight"] <= weight:
				result.append(item["item"])
				found = true
	return result
