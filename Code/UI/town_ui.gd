extends RGameplayControl

func _ready() -> void:
	super()
	Signals.ToggleTownUI.connect(_toggle_ui)

func _toggle_town_ui(_value:=false):
	if _value: 
		show()
		Signals.ToggleDungeonUI.emit(false)
	else: hide()
