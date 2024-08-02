extends RCanvasLayer

var dungeon_ui:Control
var town_ui:Control

func _ready():
	Signals.ToggleDungeonUI.connect(_toggle_dugeon_ui)
	Signals.ToggleTownUI.connect(_toggle_town_ui)
	dungeon_ui = get_tree().get_first_node_in_group("dungeon_ui")
	town_ui = get_tree().get_first_node_in_group("town_ui")

func _toggle_dugeon_ui(_value:=false):
	if dungeon_ui:
		if _value: dungeon_ui.show()
		else: dungeon_ui.hide()

func _toggle_town_ui(_value:=false):
	if town_ui:
		if _value: town_ui.show()
		else: town_ui.hide()
