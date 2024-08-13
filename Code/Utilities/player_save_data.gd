class_name PlayerSaveData extends Resource

@export var save_count := 0
@export var rng_seed := ""
@export var rng_hash := ""

@export var currencies := {"gold":100}
@export var inventory:Array = [{"slot":1, "item_id":1, "count":1}, {"slot":0, "item_id":0, "count":10}]
@export var stash:Array = [{"slot":1, "item_id":1, "count":1}]
#stash format: {"slot":1, "item_id":1, "count":1}

@export var inventory_page_count := 3:
	get:
		return roundi(inventory.size() / slots_per_page) if inventory.size() / slots_per_page > 0 else 1
@export var slots_per_page := 16:
	get:
		return inventory_rows * inventory_columns
@export var inventory_rows := 4
@export var inventory_columns := 4

func get_save_dict() -> Dictionary:
	save_count += 1
	return {
		"save_count":save_count,
		"rng_seed":rng_seed,
		"rng_hash":rng_hash,
		"inventor":inventory,
		"currencies":currencies,
		"stash":stash,
		"inventory_page_count":inventory_page_count
	}

func set_save_data(_data:Dictionary = {}):
	if _data.has("save_count"): save_count = _data["save_count"]
	if _data.has("rng_seed"): rng_seed = _data["rng_seed"]
	if _data.has("rng_hash"): rng_hash = _data["rng_hash"]
	if _data.has("inventory"): inventory = _data["inventory"]
	if _data.has("currencies"): currencies = _data["currencies"]
	if _data.has("stash"): stash = _data["stash"]
	if _data.has("inventory_page_count"): inventory_page_count = _data["inventory_page_count"]

func add_item_to_inventory(_item:ItemData = null):
	if _item != null:
		var result = _check_if_present_in_array(inventory, _item)
		if !result.is_empty():
			if _item.can_stack:
				var added := false
				Debug.log("Adding count to item")
				for each in  result:
					if each["count"] < 99: 
						each["count"] += 1
						Signals.UpdateCountOfitemInUi.emit(each)
						added = true
						break
				if !added:
					Debug.log("Adding duplicate item")
					var slot = _get_first_avail_slot()
					var new_item := {"slot":slot, "item_id":_item.id, "count":1}
					inventory.append(new_item)
					Signals.AdditemToInventoryUi.emit(new_item)
		else:
			Debug.log("Adding new item")
			var slot = _get_first_avail_slot()
			var new_item := {"slot":slot, "item_id":_item.id, "count":1}
			inventory.append(new_item)
			Signals.AdditemToInventoryUi.emit(new_item)

func _check_if_present_in_array(_array:Array = [], _item:ItemData = null) -> Array:
	var result := []
	if !_array.is_empty() and _item != null:
		for each in _array:
			if each.has("item_id") and each["item_id"] == _item.id:
				result.append(each)
		return result
	return result

func _get_first_avail_slot() -> int:
	var temp = inventory.duplicate()
	temp.sort_custom(func(a, b): return a["slot"] < b["slot"])
	Debug.log(temp)
	var slot := 0
	for each in temp:
		if slot == each["slot"]:
			slot += 1
		elif slot < each["slot"]:
			break
	Debug.log("returning slot: ", slot)
	return slot
