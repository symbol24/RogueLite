class_name DungeonUi extends RGameplayControl

func _ready():
	super()
	Signals.ToggleDungeonUI.connect(_toggle_ui)
	Signals.UiElementReady.connect(_check_all_children_ready)
