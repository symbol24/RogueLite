class_name ProduceInteractable extends RInteractable

@onready var highlight: Sprite2D = %highlight
@onready var spawn_point: Marker2D = %spawn_point

func interact(_player_currencies:Dictionary) -> Dictionary:
	#Debug.log("Pressing interact")
	var cost = data.get_cost()
	match cost["currency"]:
		GM.CURRENCIES.NOTHING:
			hide()
			Signals.SpawnFromLootTable.emit(data.loot_table, spawn_point.global_position, data.amount)
			return {"result":true}
		_:
			pass
	return {"result":false,
			"reason":"Error in cost or player"}
	
func _area_entered(_area):
	if active and !highlight.is_visible():
		highlight.show()
	
func _area_exited(_area):
	if highlight.is_visible():
		highlight.hide()
