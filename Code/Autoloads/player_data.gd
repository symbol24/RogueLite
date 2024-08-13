extends Node

const FOLDER = "user://save/"
const FILE = "game.save"
const JSONTHING = "VVRASG#$f2"

var data:PlayerSaveData

func _ready():
	Signals.Save.connect(save)
	Signals.Load.connect(load_data)
	Signals.AddItem.connect(_add_item)

func load_data():
	if not FileAccess.file_exists(FOLDER+FILE):
		return {"result": "Missing save file"}
	var save_file = FileAccess.open_encrypted_with_pass(FOLDER+FILE, FileAccess.READ,JSONTHING)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		Debug.log("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	var save_file_data = json.get_data()
	save_file.close()
	data = PlayerSaveData.new()
	data.set_save_data(save_file_data)
	Debug.log("Save count: ", data.save_count)

func save():
	if not DirAccess.open(FOLDER):
		var _res = DirAccess.make_dir_absolute(FOLDER)
	var to_save := {"save":"data"}
	if data != null:
		to_save = data.get_save_dict()

	var save_file = FileAccess.open_encrypted_with_pass(FOLDER+FILE, FileAccess.WRITE, JSONTHING)
	var json_string = JSON.stringify(to_save)
	save_file.store_line(json_string)
	save_file.close()

func _add_item(_item:ItemData = null):
	if _item != null:
		data.add_item_to_inventory(_item)
