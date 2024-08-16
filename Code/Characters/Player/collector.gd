class_name Collector extends RArea2D

var r_owner:DungeonCharacter

func _ready():
	r_owner = get_parent()
	area_entered.connect(_area_entered)
	
func _area_entered(_area):
	if _area.get_parent() is Collectible:
		if PlayerData.check_if_can_collect(_area.get_parent().data, _area.get_parent().amount):
			var result = _area.get_parent().collect()
			if result.has("item") and result.has("amount"):
				#Debug.log("Is result item an itemdata? ", result["item"] is ItemData)
				Signals.Collect.emit(r_owner.data, result["item"], result["amount"])
		else: 
			Signals.DisplayPopup.emit("inventory_full", PopupManager.TYPE.TEXT)
			Debug.warning("Inventory full")
