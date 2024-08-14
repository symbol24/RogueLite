class_name Collectible extends RigidBody2D

var data:ItemData
var item_texture
var amount := 1

func set_data(_data:ItemData, _amount := 1):
	if _data != null:
		data = _data
		if _amount > 1: amount = _amount
		var new_texture = _data.texture.instantiate() as ItemTexture
		item_texture = new_texture.duplicate()
		add_child.call_deferred(item_texture)
		item_texture.position = Vector2.ZERO

func collect(_owner:MainCharacterData):
	Signals.Collect.emit(_owner, data, amount)
	queue_free.call_deferred()
