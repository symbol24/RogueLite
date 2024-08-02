class_name RDungeon extends RPlayWorld

func _ready():
	super()
	Signals.ToggleDungeonUI.emit(true)
