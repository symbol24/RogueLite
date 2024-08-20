class_name ButtonSwapping extends ButtonSwapper

@onready var gamepad_label: RRichTextLabel = %gamepad_label
@onready var kbm_button: Button = %kbm_button

func _ready() -> void:
	super()
	#
	#if data != null:
		#gamepad_label.text = data.label_text
		#kbm_button.text = data.label_text
