class_name LootTable extends Resource

@export var id := ""
##Each item should have a "weight" as int and an "item" as data
@export var list:Array[Dictionary]


func get_loot(_amount := 1) -> Array:
	var result := []
	var temp = list.duplicate(true)
	var total := 0
	for item in temp:
		total += item["weight"]
		item["weight"] = total
	
	var choice = -1
	#Debug.log("Choice: ", choice)
	var chosen:Array[Dictionary] = []
	for x in _amount:
		var to_add = temp.pick_random()
		choice = GM.rng.randi_range(0, total)
		for item in temp:
			if item["weight"] <= choice:
				to_add = item
		while _check_if_max_reached(to_add, chosen):
			for item in temp:
				if item["weight"] <= choice:
					to_add = item
		chosen = _update_chosen_array(chosen, to_add)
		result.append(to_add["item"])
	return result

func _check_if_max_reached(_item_dict := {}, _chosen:Array[Dictionary] = []) -> bool:
	var max_reached := false
	if _chosen.is_empty():
		return max_reached
	if !_item_dict.is_empty():
		for each in _chosen:
			Debug.log("each: ", "each['spawn_count'] < _item_dict['spawn_max'] ", each["spawn_count"], " < ", _item_dict["spawn_max"])
			if each.has("spawn_count") and _item_dict["item"] == each["item"] and each["spawn_count"] < _item_dict["spawn_max"]:
				max_reached = true
				break
			
	return max_reached

func _update_chosen_array(_chosen: Array[Dictionary] = [], _item_dict := {}) -> Array[Dictionary]:
	if _item_dict.has("item"):
		var found := false
		for each in _chosen:
			if each["item"] == _item_dict["item"]:
				if each.has("spawn_count"): each["spawn_count"] += 1
				found = true
				break
		if !found:
			var new = _item_dict.duplicate(true)
			new["spawn_count"] = 1
			_chosen.append(new)
	return _chosen
