extends RMenuWorld

@onready var town:Button = %town
@onready var dungeon:Button = %dungeon
@onready var save_button:Button = %save
@onready var load_button:Button = %load
@onready var delete:Button = %delete

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	save_button.pressed.connect(_save)
	load_button.pressed.connect(_load)
	delete.pressed.connect(_delete)
	town.pressed.connect(_town)
	dungeon.pressed.connect(_dungeon)
	Signals.UIReady.emit()
	town.grab_focus()
	
func _town() -> void:
	Signals.LoadNewWorld.emit("test_town")

func _dungeon() -> void:
	Signals.LoadNewWorld.emit("test_dungeon")

func _save() -> void:
	Signals.Save.emit()

func _load() -> void:
	Signals.Load.emit()

func _delete() -> void:
	Signals.DeleteSave.emit()
