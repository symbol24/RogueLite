extends Node

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

var playing := true:
	set(value):
		#SASignals.IsPlaying.emit(value)
		playing = value
var camera:Camera2D = null
var is_debug := true

#RNG
var seed := "Symbol24"
var hash = seed.hash()
var rng = RandomNumberGenerator.new()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.set_seed(hash)

func is_playing() -> bool:
	return playing
