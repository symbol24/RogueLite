extends RGameplayControl

func _ready():
	super()
	Signals.ToggleDungeonUI.connect(_toggle_ui)
	Signals.HPBarSetupDone.connect(_hp_bar_done)

func _hp_bar_done():
	children_ready += 1
	_check_all_children_ready()
