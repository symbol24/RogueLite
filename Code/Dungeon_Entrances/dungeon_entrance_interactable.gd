class_name DungeonEntranceInteractable extends RInteractable

@onready var interact_collider:CollisionShape2D = %interact_collider
@onready var button_icon = %button_icon

func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func interact(_player_currencies:Dictionary) -> Dictionary:
	var cost = data.get_cost()
	match cost["currency"]:
		GM.CURRENCIES.NOTHING:
			#Debug.log("triggering load to dungeon")
			Signals.LoadNewWorld.emit(data.destination)
			return {"result":true}
		_:
			pass
	return {"result":false,
			"reason":"Error in cost or player"}

func _area_entered(_area):
	if _area.get_parent() is InteractAction:
		can_interact = true
		button_icon.show()
	
func _area_exited(_area):
	if _area.get_parent() is InteractAction:
		can_interact = false
		button_icon.hide()
