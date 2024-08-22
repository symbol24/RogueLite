class_name GearData extends Resource

@export var gear_name := ""
var id := 0
@export var gear_type := GM.GEARTYPE.HELMET
@export var stats:Array[Dictionary] = []
@export var abilities:Array = []
@export var texture:Resource
@export var animation := ""
@export var action_paths:Array[String] = []

func set_id_hash() -> int:
	if id == 0:
		id = hash(gear_name)
	return id

func get_value(_id = "") -> float:
	for stat in stats:
		if stat.has(_id):
			return stat[_id]
	return 0.0

func get_instantiated_actions() -> Array:
	var array := []
	for each in action_paths:
		if each != "":
			var temp = load(each).instantiate()
			array.append(temp)
	return array
