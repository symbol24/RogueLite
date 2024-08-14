@tool
class_name ItemManager extends Node

const ITEM_FOLDER := "res://Data/Items/"
const TABLES_FOLDER :=  "res://Data/Loot/Tables/"
const ALL_ITEMS = preload("res://Data/Loot/Tables/all_items.tres")

@export var run_get_all_items := false:
	set(_value):
		run_get_all_items = _value
		ALL_ITEMS.list.clear()
		var all = load_all_from_folder(ITEM_FOLDER)
		#print(all)
		var new_list:Array = []
		for each:ItemData in all:
			if each.id != hash(each.item_name):
				each.id = hash(each.item_name)
			ResourceSaver.save(each)
			new_list.append({"item":each})
		ALL_ITEMS.list.append(new_list)
		var result = ResourceSaver.save(ALL_ITEMS)
		if result == 0: print("Get all items completed")
		else: printerr("Get all items failed with code: ", result)
		run_get_all_items = false

func _ready():
	Signals.DebugAddRandomItem.connect(_debug_add_random_item)

func get_item(_id: int) -> ItemData:
	for list in ALL_ITEMS.list:
		for each in list:
			#Debug.log("item? ", each)
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

func _debug_add_random_item():
	var item = ALL_ITEMS.list.pick_random()
	Signals.AddItem.emit(item["item"])
