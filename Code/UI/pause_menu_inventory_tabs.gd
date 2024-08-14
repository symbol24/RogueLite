class_name InventoryTabs extends HBoxContainer

const DOTUI = preload("res://Scenes/UI/dot.tscn")

@onready var dots = %dots

func add_dots(_amount := 0):
	if _amount > 0:
		for x in _amount:
			var dot = DOTUI.instantiate()
			dots.add_child.call_deferred(dot)
			dot.id = x
