class_name InventoryDisplayItem extends RControl

@export var data:ItemData

@onready var count:RRichTextLabel = %count
@onready var item_texture:ItemTexture = %ItemTexture
@onready var shadow:ItemTexture = %shadow

var current_slot := -1
var stack := 0
var grabbed := false

func _ready():
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func set_display_item_name(_value := ""):
	if _value:
		name = _value

func set_slot(_value := -1):
	if _value != -1:
		current_slot = _value

func set_textures(_texture:ItemTexture):
	item_texture = _texture.duplicate()
	shadow = _texture.duplicate()
	shadow.set_deferred("modulate", 00000089)

func set_stack(_count := 0):
	if _count >= 2:
		count.show()
		count.text = str(_count)
	else: count.hide()

func toggle_grab(_value := false):
	grabbed = _value
	shadow.set_deferred("visible", _value)

func _mouse_entered():
	Signals.SetHoverOnSquare.emit(current_slot)
	
func _mouse_exited():
	Signals.RemoveHoverOnSquare.emit(current_slot)
