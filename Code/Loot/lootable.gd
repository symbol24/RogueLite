class_name Lootable extends Collectible

var can_be_collected := false
var timer := 0.0
var delay := 0.3

func _process(_delta):
	if !can_be_collected:
		timer += _delta
		if timer >= delay:
			can_be_collected = true

func collect(_owner:MainCharacterData):
	if can_be_collected:
		Signals.Collect.emit(_owner, data, amount)
		queue_free.call_deferred()
