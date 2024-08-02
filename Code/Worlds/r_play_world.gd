class_name RPlayWorld extends RWorld


var spawn_points:Array[SpawnPoint] = []

func _ready():
	spawn_points = _setup_spawn_points()
	Signals.WorldReady.emit(self)
	Signals.UpdateInputFocus.emit(RInput.FOCUS.GAMEPLAY)
	
func _setup_spawn_points() -> Array[SpawnPoint]:
	var temp = get_tree().get_nodes_in_group("spawnpoint")
	var spawns: Array[SpawnPoint] = []
	for each in temp:
		if each is SpawnPoint:
			spawns.append(each)
	
	if spawns.is_empty():
		Debug.error("World ", name, " does not contain any spawn points.")
	
	return spawns

func get_start_spawnpoint() -> SpawnPoint:
	var to_return:SpawnPoint
	var i = 0
	for point in spawn_points:
		if point.start and i < 1:
			to_return = point
			i += 1
		elif point.start:
			i += 1
	
	if i > 1: Debug.warning("World ", name, " contains more than 1 start spawn point, first is returned.")
	elif i == 0: Debug.error("World ", name, " is missing spawn point and null is returned.")
	
	return to_return
