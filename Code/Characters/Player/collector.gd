class_name Collector extends RArea2D

var r_owner:DungeonCharacter

func _ready():
	r_owner = get_parent()
	area_entered.connect(_area_entered)
	
func _area_entered(_area):
	if _area.get_parent() is Collectible:
		if PlayerData.check_if_can_collect(_area.get_parent().data, _area.get_parent().amount):
			_area.get_parent().collect(r_owner.data)
		else: 
			Signals.DisplayError.emit("inventory_full")
			Debug.error("Invetory full")
