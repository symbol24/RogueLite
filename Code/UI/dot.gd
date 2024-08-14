class_name DOT extends RControl

@onready var normal = %normal
@onready var highlight = %highlight

var id := 0

func _ready():
	Signals.PauseMenuInventoryToggleDot.connect(_toggle_highlight)

func _toggle_highlight(_id := 0):
	#Debug.log("dot id: ", id, " and _id: ", _id)
	if _id == id:
		highlight.show()
		normal.hide()
	else:
		highlight.hide()
		normal.show()
