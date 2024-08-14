class_name Collectible extends RigidBody2D

var data:ItemData
var item_texture
var amount := 1
var can_be_collected := true

func set_data(_data:ItemData, _amount := 1):
	if _data != null:
		data = _data
		if _amount > 1: amount = _amount
		var new_texture = _data.texture.instantiate() as ItemTexture
		item_texture = new_texture.duplicate()
		add_child.call_deferred(item_texture)
		item_texture.position = Vector2.ZERO

func collect() -> Dictionary:
	if can_be_collected:
		can_be_collected = false
		get_tree().create_timer(0.1).timeout.connect(_destroy)
		return {"item":data.duplicate(), "amount":amount}
	return {}
	
func _destroy():
	queue_free.call_deferred()
