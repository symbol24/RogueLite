class_name RInteractable extends RArea2D

@export var data:InteractableData

var active := true
var can_interact := false

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)
	
func _area_entered(_area):
	pass
	
func _area_exited(_area):
	pass

func get_cost() -> Dictionary:
	if data:
		return data.get_cost()
	return {"currency":GM.CURRENCIES.GOLD,
			"cost": 10000}

func interact(_player_currencies:Dictionary) -> Dictionary:
	var cost = data.get_cost()
	match cost["currency"]:
		GM.CURRENCIES.NOTHING:
			return {"result":true}
		GM.CURRENCIES.GOLD:
			if _player_currencies.has("gold"):
				if _player_currencies["gold"] >= cost["cost"]:
					return  {"result":true,
							"currency":GM.CURRENCIES.GOLD,
							"cost":cost["cost"]}
				else:
					return {"result":false,
							"reason":"Insufficient Gold"}
			else:
				return {"result":false,
						"reason":"Insufficient Gold"}
		_:
			pass
	return {"result":false,
			"reason":"Error in cost or player"}
