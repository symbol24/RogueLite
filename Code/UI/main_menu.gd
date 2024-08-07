extends RMenuWorld

@onready var town:Button = %town
@onready var dungeon:Button = %dungeon

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	town.pressed.connect(_town)
	dungeon.pressed.connect(_dungeon)
	Signals.UIReady.emit()
	town.grab_focus()
	
func _town():
	Signals.LoadNewWorld.emit("test_town")

func _dungeon():
	Signals.LoadNewWorld.emit("test_dungeon")
