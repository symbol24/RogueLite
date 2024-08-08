class_name RPlayWorld extends RWorld

var spawn_points:Array[SpawnPoint] = []

func _ready():
	spawn_points = _setup_spawn_points()
	Signals.UpdateInputFocus.emit(RInput.FOCUS.GAMEPLAY)
	await get_tree().create_timer(1).timeout
	Signals.WorldReady.emit(self)
	
func _setup_spawn_points() -> Array[SpawnPoint]:
	var temp = get_tree().get_nodes_in_group("spawnpoint")
	var spawns: Array[SpawnPoint] = []
	var x = 0
	for each in temp:
		if each is SpawnPoint:
			each.name = "spawn_point" + str(x)
			spawns.append(each)
			x+=1
	
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

func get_spawn_by_name(_name := "") -> SpawnPoint:
	for each in spawn_points:
		if each.name == _name:
			return each
	Debug.error("Spawn point ", _name, " not found in ", name)
	return get_start_spawnpoint()
