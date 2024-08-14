class_name Collector extends RArea2D

var r_owner:DungeonCharacter

func _ready():
	r_owner = get_parent()
	area_entered.connect(_area_entered)
	
func _area_entered(_area):
	if _area.get_parent() is Collectible:
		_area.get_parent().collect(r_owner.data)
