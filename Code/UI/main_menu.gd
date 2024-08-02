extends RMenuWorld

@onready var town:Button = %town
@onready var dungeon:Button = %dungeon

func _ready():
	town.pressed.connect(_town)
	dungeon.pressed.connect(_dungeon)
	
func _town():
	Signals.LoadNewWorld.emit("test_town")

func _dungeon():
	Signals.LoadNewWorld.emit("test_dungeon")