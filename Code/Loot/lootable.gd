class_name Lootable extends Collectible

var timer := 0.0
var delay := 0.3

func _ready():
	can_be_collected = false

func _process(_delta):
	if !can_be_collected:
		timer += _delta
		if timer >= delay:
			can_be_collected = true
