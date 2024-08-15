class_name RDungeonUiElement extends RControl

var dungeon_ui:DungeonUi

func _ready():
	super()
	process_mode = Node.PROCESS_MODE_ALWAYS
	dungeon_ui = get_parent()

func _toggle_ui(_value):
	if dungeon_ui.is_visible():
		if _value:show()
		else: hide()
