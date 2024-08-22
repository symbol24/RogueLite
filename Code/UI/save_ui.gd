class_name SaveUi extends RControl

@onready var animator:RAnimator = %animator

var timer := 0.0
var delay := 5.0

func _ready() -> void:
	super()
	Signals.Save.connect(_toggle_ui)

func _process(_delta):
	if animator.is_playing():
		timer += _delta
		if timer >= delay:
			animator.stop()
			timer = 0.0
			_toggle_ui(false)

func _toggle_ui(_value := true):
	if _value:
		show()
		_play_fade()
	else: hide()

func _play_fade() -> void:
	animator.play("fade")
	
