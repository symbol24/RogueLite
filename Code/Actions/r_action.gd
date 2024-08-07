class_name RAction extends Node2D

var r_owner:RCharacter
var can_action := true
var action_available:bool:
	get:
		return GM.is_playing() and r_owner and !r_owner.state_machine.is_state("dead") and r_owner.data is RCharacterData and r_owner.data

func _ready():
	r_owner = get_parent() as RCharacter
