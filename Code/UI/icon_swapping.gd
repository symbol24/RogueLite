class_name IconSwapping extends ButtonSwapper

@onready var label: RRichTextLabel = %label

func _ready() -> void:
	super()
	#if data != null:
		#label.text = data.label_text
#
#func _load_kbm_icons() -> void:
	#if data != null and data.kbm != null:
		#kbm = data.kbm.instantiate()
		#gamepad.add_child.call_deferred(kbm)
