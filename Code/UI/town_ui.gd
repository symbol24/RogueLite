extends RGameplayControl

func _ready():
	super()
	Signals.ToggleTownUI.connect(_toggle_ui)

func _toggle_town_ui(_value:=false):
	if _value: show()
	else: hide()
