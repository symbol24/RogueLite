class_name ProduceInteractable extends RInteractable

var parent:ProduceItem

func _ready() -> void:
	super()
	parent = get_parent() as ProduceItem

func interact(_player_currencies:Dictionary) -> Dictionary:
	#Debug.log("Pressing interact")
	var cost = data.get_cost()
	match cost["currency"]:
		GM.CURRENCIES.NOTHING:
			#Debug.log("triggering load to dungeon")
			if parent != null:
				parent.hide()
				parent.spawn_produce(data.produce_item_data)
				parent.queue_free.call_deferred()
			return {"result":true}
		_:
			pass
	return {"result":false,
			"reason":"Error in cost or player"}
	
func _area_entered(_area):
	if parent != null:
		parent.toggle_highlight(true)
	
func _area_exited(_area):
	if parent != null:
		parent.toggle_highlight(false)
