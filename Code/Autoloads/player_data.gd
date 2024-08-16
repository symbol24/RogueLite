extends Node

const FOLDER = "user://save/"
const FILE = "game.save"
const JSONTHING = "VVRASG#$f2"

var data:PlayerSaveData
var collect_timer:SceneTreeTimer


func _ready():
	Signals.Save.connect(_save)
	Signals.Load.connect(_load)
	Signals.DeleteSave.connect(_delete_save)
	Signals.AddItem.connect(_add_item)
	Signals.Collect.connect(_collect)

func _load():
	if not FileAccess.file_exists(FOLDER+FILE):
		Debug.log("creating new SAVE file")
		Signals.Save.emit()
		return {"result": "Missing save file"}
	var save_file
	if GM.is_debug: save_file = FileAccess.open(FOLDER+FILE, FileAccess.READ)
	else: save_file = FileAccess.open_encrypted_with_pass(FOLDER+FILE, FileAccess.READ, JSONTHING)
	
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

func _save():
	if not DirAccess.open(FOLDER):
		var _res = DirAccess.make_dir_absolute(FOLDER)
	var to_save := {"save":"data"}
	if data != null:
		to_save = data.get_save_dict()
	else:
		data = PlayerSaveData.new()
		to_save = data.get_save_dict()

	var save_file
	if GM.is_debug: save_file = FileAccess.open(FOLDER+FILE, FileAccess.WRITE)
	else: save_file = FileAccess.open_encrypted_with_pass(FOLDER+FILE, FileAccess.WRITE, JSONTHING)
		
	var json_string = JSON.stringify(to_save)
	save_file.store_line(json_string)
	save_file.close()

func _delete_save():
	if FileAccess.file_exists(FOLDER+FILE):
		var dir = DirAccess.open(FOLDER)
		var result = dir.remove(FOLDER+FILE)
		if result == 0: 
			data = null
			Debug.log("Save file deleted")
		else: Debug.error("Delete save file error: ", result)

func _add_item(_item:ItemData = null, _amount := 1):
	if _item != null:
		data.add_item_to_inventory(_item, _amount)

func _collect(_data:MainCharacterData = null, _item_data:ItemData = null, _amount := 1):
	#Debug.log("Received data: ", _data.id, " and item: ", _item_data.item_name, " for amount: ", _amount)
	if _data is MainCharacterData and _item_data != null:
		data.add_item_to_inventory(_item_data, _amount)
		_save_delay(5.0)

func _save_delay(_value := 5.0):
	if collect_timer != null and collect_timer.time_left > 0.0:
		collect_timer.time_left = _value
	else:
		collect_timer = get_tree().create_timer(_value)
		if !collect_timer.is_connected("timeout", _save_timer_timeout):
			collect_timer.timeout.connect(_save_timer_timeout)

func _save_timer_timeout():
	Signals.Save.emit()

func check_if_can_collect(_item:ItemData = null, _amount := 1) -> bool:
	if _item != null:
		var can_add := false
		if _item.can_stack:
			var result = data._check_if_present_in_array(data.inventory, _item)
			for each in  result:
				if each["count"] < 99-_amount: 
					can_add = true
					break
		
		if !can_add:
			if data.inventory.size() < data.inventory_size-1:
				can_add = true
		
		return can_add
	return false
