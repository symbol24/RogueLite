class_name RAction extends Node2D

var r_owner:RCharacter
var can_action := true

func _ready():
	r_owner = get_parent() as RCharacter
