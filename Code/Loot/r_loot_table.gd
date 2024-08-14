class_name LootTable extends Resource

@export var id := ""
##Each item should have a "weight" as int and an "item" as data
@export var list:Array[Array]


func get_loot() -> Array:
	var result := []
	var temp = list.duplicate(true)
	for table in temp:
		Debug.log("table: ", table)
		if table.size() > 1:
			var total := 0
			for item in table:
				total += item["weight"]
				item["weight"] = total
			
			Debug.log("table post weight: ", table)
			var added := false
			var choice = GM.rng.randi_range(0, total)
			Debug.log("Choice: ", choice)
			for item in table:
				if !added and item["weight"] <= choice:
					Debug.log("adding item: ", item["item"].item_name)
					result.append(item["item"])
					added = true
		elif table.size() == 1:
			result.append(table[0]["item"])
	return result

func _old_get_loot():
	var result := []
	var temp = list.duplicate(true)
	for table in temp:
		var total := 0
		for item in table:
			Debug.log("Item: ", item["item"].item_name)
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
	Debug.log("Loot returned: ", result)
	return result
