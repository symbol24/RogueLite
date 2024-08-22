@tool
class_name ItemManager extends Node

const ITEM_FOLDER := "res://Data/Items/"
const TABLES_FOLDER :=  "res://Data/Loot/Tables/"
const ALL_ITEMS = "res://Data/Loot/Tables/all_items.tres"

@export var run_get_all_items := false:
	set(_value):
		run_get_all_items = _value
		var all_items = load(ALL_ITEMS)
		all_items.list.clear()
		var all = load_all_from_folder(ITEM_FOLDER)
		#print(all)
		for each:ItemData in all:
			if each.id != hash(each.item_name):
				each.id = hash(each.item_name)
			ResourceSaver.save(each)
			all_items.list.append({"item":each})
		var result = ResourceSaver.save(all_items, ALL_ITEMS)
		if result == 0: print("Get all items completed")
		else: printerr("Get all items failed with code: ", result)
		run_get_all_items = false

func _ready() -> void:
	Signals.DebugAddRandomItem.connect(_debug_add_random_item)

func get_item(_id: int) -> ItemData:
	var all_items = load(ALL_ITEMS)
	for each in all_items.list:
		if each["item"].id == int(_id) and each.has("item"): return each["item"]
	return null

func load_all_from_folder(_folder) -> Array:
	var to_return:Array =[]
	var dir = DirAccess.open(_folder)
	var subs = dir.get_directories()
	var files
	for sub in subs:
		files = DirAccess.get_files_at(_folder+"/"+sub)
		for file in files:
			if file.get_extension() == "tres":
				to_return.append(load(_folder+"/"+sub+"/"+file))
	files = DirAccess.get_files_at(_folder)
	for file in files:
		if file.get_extension() == "tres":
			to_return.append(load(_folder+file))
	return to_return

func _debug_add_random_item() -> void:
	var all_items = load(ALL_ITEMS)
	var item = all_items.list.pick_random()
	Signals.AddItem.emit(item["item"])
