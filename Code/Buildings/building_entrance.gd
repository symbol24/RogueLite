extends RInteractable

@onready var button_icon = %button_icon

func _area_entered(_area):
	if _area.get_parent() is InteractAction:
		can_interact = true
		button_icon.show()
	
func _area_exited(_area):
	if _area.get_parent() is InteractAction:
		can_interact = false
		button_icon.hide()

func interact(_player_currencies:Dictionary) -> Dictionary:
	var cost = data.get_cost()
	match cost["currency"]:
		GM.CURRENCIES.NOTHING:
			Debug.log("triggering load to building")
			Signals.LoadBuilding.emit(data.building_path, get_parent().spawn_point.name)
			return {"result":true}
		_:
			pass
	return {"result":false,
			"reason":"Error in cost or player"}
