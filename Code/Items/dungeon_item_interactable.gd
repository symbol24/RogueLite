class_name DungeonItemInteractable extends RInteractable

@onready var closed: TileMapLayer = %closed
@onready var open: TileMapLayer = %open
@onready var y_button: Node2D = %y_button
@onready var loot_point: Marker2D = %loot_point

func _area_entered(_area):
	if active and !y_button.is_visible():
		y_button.show()
	
func _area_exited(_area):
	if y_button.is_visible():
		y_button.hide()

func interact(_player_currencies:Dictionary) -> Dictionary:
	if active:
		var cost = data.get_cost()
		Debug.log("interacting with cheeest")
		match cost["currency"]:
			GM.CURRENCIES.NOTHING:
				open.show()
				closed.hide()
				Signals.SpawnFromLootTable.emit(data.loot_table, loot_point.global_position, data.loot_amount)
				active = false
				y_button.hide()
				return {"result":true}
			_:
				pass
		return {"result":false,
				"reason":"Error in cost or player"}
	return {}
