extends Node

const WORLDS = [
				{"id":"test_town", "preload":preload("res://Scenes/Worlds/test_town.tscn")},
				{"id":"test_dungeon", "preload":preload("res://Scenes/Worlds/test_dungeon.tscn")},
				{"id":"main_menu", "preload":preload("res://Scenes/Worlds/main_menu.tscn")}
				]

const ROGUE_CHARACTER = preload("res://Scenes/Characters/Player/rogue_character.tscn")

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

var playing := true:
	set(value):
		#SASignals.IsPlaying.emit(value)
		playing = value

var world:RWorld
var character:RCharacter
var camera:Camera2D = null

#build inf
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
			var new_char = ROGUE_CHARACTER.instantiate()
			world.add_child.call_deferred(new_char)
			new_char.global_position = spawn_point.global_position

func _get_world(_id := "") -> PackedScene:
	for world in WORLDS:
		if world["id"] == _id:
			return world["preload"]
	Debug.error("Id ", _id, " not found in world list.")
	return null

func _load_new_world(_id:=""):
	var new = _get_world(_id)
	get_tree().change_scene_to_packed(new)
