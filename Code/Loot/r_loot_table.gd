class_name LootTable extends Resource

@export var id := ""
##Each item should has a "weight" as int and an "item" as data
@export var list:Array[Dictionary]


func get_loot():
	var temp = list.duplicate(true)
	var total := 0
	for item in temp:
		if item.has("weight") and item["weight"] is int:
			total += item["weight"]
			item["weight"] = total
	var c = randi_range(0,3)
	var i = 0
	while i < c:
		temp.shuffle()
		i+=1
	var weight = GM.rng.randi_range(0, total)
	for each in temp:
		if each.has("weight") and each["weight"] <= weight:
			return each
	return null
