extends Node

enum CURRENCIES {GOLD = 0, NOTHING = 1}
enum ITEMRARITY {COMMON = 1, UNCOMMON = 2, RARE = 3, EXQUISITE = 4, LEGENDARY = 5}

const WORLDS = [
				{"id":"test_town", "path":"res://Scenes/Worlds/test_town.tscn"},
				{"id":"test_dungeon", "path":"res://Scenes/Worlds/test_dungeon.tscn"},
				{"id":"main_menu", "path":"res://Scenes/Worlds/main_menu.tscn"}
				]

const CHARACTER_DUNGEON = preload("res://Scenes/Characters/Player/character_dungeon.tscn")
const CHARACTER_TOWN = preload("res://Scenes/Characters/Player/character_town.tscn")
const CAMERA = preload("res://Scenes/Utilities/r_camera.tscn")

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

var playing := true
var character:RCharacter
var camera:Camera2D = null
var dungeon_run_ended := false


#Loading
var last_load_id := ""
var loaded_worlds:Array[Dictionary] = []
var world:RWorld:
	set(_value):
		if _value:
			world = _value
			#Debug.log("World is ", world.name)
		else:
			Debug.error("Attempting to assign a null to world in GM.")
	
var building:RBuilding
var building_entrance_spawn_point:String
var loading := ""
var loading_building := ""
var is_loading := false
var is_loading_building := false
var load_complete := false
var loading_status := 0.0
var progress := []
var ui_ready := false
var extra_loading := false
var loading_timer := 0.0
var loading_delay := 1.0

#items
var item_manager:ItemManager:
	set(_value):
		item_manager = _value
		if item_manager != null: Signals.ItemManagerIsSet.emit(item_manager)

#build info
var is_debug := true

#RNG
var rng_seed := "Symbol24"
var rng_hash = rng_seed.hash()
var rng = RandomNumberGenerator.new()

# LOADING PLAYING WORLD LOGIC
# 1 - receiving loading signal (LoadNewWorld)
# 2 - display loading screen: ToggleLoadingScreen
# 3 - load world (_load_new_world)
# 4 - load complete (_complete_load)
# 5 - world ready signal received, set into world variable (WorldReady)
# 6 - Character loades from world set signal (WorldSet)
# 7 - Character ready signal sets character in variable (CharacterReady signal, character var)
# 8 - UI ready signal spawns Camera
# 9 - UI ready signal triggers removes loading UI and allows start of gameplay (UIReady)

# LOADING BUILDING LOGIC
# 1 - receiving loading signal (LoadBuilding)
# 2 - display loading screen: ToggleLoadingScreen
# 3 - load building (_load_building)
# 4 - load complete (_complete_load_building)
# 5 - add new building as child of world
# 6 - Move character to building interior
# 7 - display game

# UNLOADING (exiting) BUILDING LOGIC
# 1 - receiving unloading signal (ExitBuilding)
# 2 - display loading screen: ToggleLoadingScreen
# 3 - Move character to world at building exterior door
# 4 - Delete building
# 5 - display game

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.set_seed(rng_hash)
	Signals.LoadNewWorld.connect(_load_new_world)
	Signals.CharacterReady.connect(_set_character)
	Signals.CharacterNoMoreLives.connect(_end_run)
	Signals.EndRunCheck.connect(_end_run_check)
	Signals.WorldReady.connect(_set_world)
	Signals.WorldSet.connect(_spawn_main_character)
	Signals.UIReady.connect(_ui_ready)
	Signals.TogglePause.connect(_toggle_pause)
	Signals.ToggleEndRun.connect(_toggle_end_run)
	Signals.LoadBuilding.connect(_load_building)
	Signals.ExitBuilding.connect(_unload_building)
	Signals.DebugEndRun.connect(_toggle_end_run)
	Signals.SetItemManager.connect(_set_item_manager)

func _process(_delta):
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(loading, progress)
		#Debug.log("loading world: ", progress[0]*100, "%")
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()
	
	if is_loading_building:
		loading_status = ResourceLoader.load_threaded_get_status(loading_building, progress)
		#Debug.log("loading building: ", progress[0]*100, "%")
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load_building()

func _toggle_pause(_value := false):
	playing = !_value
	if world and world is RPlayWorld:
			Signals.TogglePauseMenu.emit(!playing)
	get_tree().set_deferred("paused", _value)

func _toggle_end_run(_value := false):
	if world and world is RDungeon:
		playing = !_value
		Signals.ToggleEndRunMenu.emit(!playing)
		Signals.UpdateInputFocus.emit(RInput.FOCUS.UIFOCUS)
		get_tree().set_deferred("paused", _value)

func is_playing() -> bool:
	return playing

func _set_character(_character:RCharacter):
	if _character:
		character = _character
		Signals.CharacterSet.emit(character.data)
	else: Debug.error("GameManager Character received null")

func _set_world(_world:RWorld):
	if _world:
		#Debug.log("Receiving _world: ", _world)
		world = _world
		Signals.WorldSet.emit(world)
	else: Debug.error("GameManager World received null")

func _spawn_main_character(_world:RWorld):
	if _world.spawn_character:
		var spawn_point = _world.get_start_spawnpoint()
		if spawn_point:
			var new_char = CHARACTER_DUNGEON.instantiate() if _world is RDungeon else CHARACTER_TOWN.instantiate()
			world.add_child.call_deferred(new_char)
			new_char.global_position = spawn_point.global_position

func _spawn_camera():
	if camera: camera.queue_free()
	camera = null
	if world:
		var new_camera = CAMERA.instantiate()
		world.add_child(new_camera)
		if world is RPlayWorld and character:
			character.camera_remote.remote_path = new_camera.get_path()
		else:
			camera.global_position = Vector2(160, 88)

func _ui_ready():
	_spawn_camera()
	await get_tree().create_timer(loading_delay).timeout
	if !playing: playing = true
	get_tree().set_deferred("paused", false)
	Signals.ToggleLoadingScreen.emit(false)

func _get_world(_id := "") -> String:
	for w in WORLDS:
		if w["id"] == _id:
			return w["path"]
	Debug.error("Id ", _id, " not found in world list.")
	return ""

func _load_new_world(_id:=""):
	Signals.ToggleLoadingScreen.emit(true)
	if !get_tree().paused: get_tree().set_deferred("paused", true)
	var loaded_world = _get_loaded_world(_id)
	if loaded_world:
		_complete_reload(loaded_world)
	else:
		loading = _get_world(_id)
		if loading:
			last_load_id = _id
			#Debug.log("Loading: ", loading)
			ResourceLoader.load_threaded_request(loading)
			is_loading = true
		else: last_load_id = ""

func _complete_reload(_world):
	#if world:
		#world.queue_free()
		#world = null
	get_tree().change_scene_to_packed(_world)
	#Debug.log("reloadind", _world)

func _complete_load():
	is_loading = false
	var new_world = ResourceLoader.load_threaded_get(loading)
	get_tree().change_scene_to_packed(new_world)
	
	var result = {"id":last_load_id,
				"world":new_world}
	loaded_worlds.append(result)
	
	if new_world is RDungeon: dungeon_run_ended = false
	#Debug.log("Scene set to: ", new_world)
	load_complete = false

func _get_loaded_world(_id:=""):
	for _w in loaded_worlds:
		if _w["id"] == _id:
			return _w["world"]
	return null

func _load_building(_path := "", _entrance := ""):
	Signals.ToggleLoadingScreen.emit(true)
	if !get_tree().paused: get_tree().set_deferred("paused", true)
	building_entrance_spawn_point = _entrance
	loading_building = _path
	if loading_building:
		ResourceLoader.load_threaded_request(loading_building)
		is_loading_building = true

func _complete_load_building():
	is_loading_building = false
	var new_building = ResourceLoader.load_threaded_get(loading_building)
	building = new_building.instantiate()
	world.add_child(building)
	building.global_position = Vector2(-40000, -40000)
	character.global_position = building.spawn_point.global_position
	load_complete = false
	if get_tree().paused: get_tree().set_deferred("paused", false)
	Signals.ToggleLoadingScreen.emit(false)

func _unload_building(_building:RBuilding):
	Signals.ToggleLoadingScreen.emit(true)
	playing = false
	if !get_tree().paused: get_tree().set_deferred("paused", true)
	if building == _building:
		character.global_position = world.get_spawn_by_name(building_entrance_spawn_point).global_position
		building_entrance_spawn_point = ""
		building.queue_free.call_deferred()
		building = null
	await get_tree().create_timer(loading_delay).timeout
	if get_tree().paused: get_tree().set_deferred("paused", false)
	playing = true
	Signals.ToggleLoadingScreen.emit(false)
	
func _end_run(_data):
	if _data == character.data:
		dungeon_run_ended = true

func _end_run_check():
	#Debug.log("dungeon_run_ended ", dungeon_run_ended)
	if dungeon_run_ended: 
		await get_tree().create_timer(1).timeout
		_toggle_end_run(true)

func _set_item_manager(_item_manager:ItemManager):
	if _item_manager:
		if item_manager != null: item_manager.queue_free.call_deferred()
		item_manager = _item_manager
