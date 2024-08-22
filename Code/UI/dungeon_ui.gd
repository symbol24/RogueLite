class_name DungeonUi extends RGameplayControl

func _ready() -> void:
	super()
	Signals.ToggleDungeonUI.connect(_toggle_ui)
	Signals.UiElementReady.connect(_check_all_children_ready)

func _toggle_ui(_value):
	if _value:
		show()
		Signals.ToggleTownUI.emit(false)
	else: hide()
