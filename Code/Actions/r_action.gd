class_name RAction extends Node2D

enum TYPE {BOTH = 0, DUNGEON = 1, TOWN = 2}

@export var action_type := TYPE.TOWN

var r_owner:RCharacter
var can_action := true
var action_available:bool:
	get:
		return GM.is_playing() and r_owner and !r_owner.state_machine.is_state("dead") and r_owner.data is RCharacterData and r_owner.data and RInput.is_focused_on_gameplay

var input_timer := 0.0
var input_delay := 0.3

func _ready() -> void:
	r_owner = get_parent() as RCharacter

func _process(_delta):
	if GM.is_playing() and !can_action:
		input_timer += _delta
		if input_timer >= input_delay:
			input_timer = 0.0
			can_action = true
