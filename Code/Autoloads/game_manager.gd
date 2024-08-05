extends Node

enum CURRENCIES {GOLD = 0, NOTHING = 1}

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

var playing := true:
	set(_value):
		playing = _value
		if world and world is RPlayWorld:
			Signals.TogglePauseMenu.emit(!playing)

var character:RCharacter
var camera:Camera2D = null

#Loading
var world:RWorld:
	set(_value):
		world = _value
		Debug.log("World is ", world.name)
	
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

#build info
var is_debug := true

#RNG
var rng_seed := "Symbol24"
var rng_hash = rng_seed.hash()
var rng = RandomNumberGenerator.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.set_seed(rng_hash)
	Signals.LoadNewWorld.connect(_load_new_world)
	Signals.CharacterReady.connect(_set_character)
	Signals.WorldReady.connect(_set_world)
	Signals.WorldSet.connect(_spawn_main_character)
	Signals.UIReady.connect(_ui_ready)
	Signals.TogglePause.connect(_toggle_pause)
	Signals.LoadBuilding.connect(_load_building)
	Signals.ExitBuilding.connect(_unload_building)

func _process(_delta):
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(loading, progress)
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()
	
	if is_loading_building:
		loading_status = ResourceLoader.load_threaded_get_status(loading_building, progress)
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load_building()
	
	if extra_loading:
		loading_timer += _delta
		if loading_timer >= loading_delay:
			extra_loading = false
			loading_timer = 0.0
			_display_game()

func _display_game():
	#SASignals.ToggleLoading.emit(false)
	_toggle_pause(false)

func _complete_load():
	is_loading = false
	var new_world = ResourceLoader.load_threaded_get(loading)
	if world:
		world.queue_free()
		world = null
	if get_tree().paused: get_tree().paused = false
	get_tree().change_scene_to_packed(new_world)
	load_complete = false

func _toggle_pause(_value := false):
	playing = !_value
	get_tree().set_pause(_value)

func is_playing() -> bool:
	return playing

func _set_character(_character:RCharacter):
	if _character:
		character = _character
		Signals.CharacterSet.emit(character.data)
	else: Debug.error("GameManager Character received null")

func _set_world(_world:RWorld):
	if _world:
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
	Signals.ToggleLoadingScreen.emit(false)

func _get_world(_id := "") -> String:
	for w in WORLDS:
		if w["id"] == _id:
			return w["path"]
	Debug.error("Id ", _id, " not found in world list.")
	return ""

func _load_new_world(_id:=""):
	Signals.ToggleLoadingScreen.emit(true)
	if !get_tree().paused: get_tree().paused = true
	loading = _get_world(_id)
	if loading:
		ResourceLoader.load_threaded_request(loading)
		is_loading = true

func _load_building(_path := "", _entrance := ""):
	Signals.ToggleLoadingScreen.emit(true)
	if !get_tree().paused: get_tree().paused = true
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
	if get_tree().paused: get_tree().paused = false
	Signals.ToggleLoadingScreen.emit(false)

func _unload_building(_building:RBuilding):
	Signals.ToggleLoadingScreen.emit(true)
	if !get_tree().paused: get_tree().paused = true
	if building == _building:
		character.global_position = world.get_spawn_by_name(building_entrance_spawn_point).global_position
		building_entrance_spawn_point = ""
		building.queue_free.call_deferred()
		building = null
	await get_tree().create_timer(loading_delay).timeout
	if get_tree().paused: get_tree().paused = false
	Signals.ToggleLoadingScreen.emit(false)
	
