class_name InteractableData extends Resource

@export var currency := GM.CURRENCIES.NOTHING
@export var cost := 0

func get_cost() -> Dictionary:
	return {"currency":currency,
			"cost": cost}
