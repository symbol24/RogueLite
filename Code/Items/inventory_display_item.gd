class_name InventoryDisplayItem extends RControl

@export var data:ItemData
@export var shadow_color:Color

@onready var count:RRichTextLabel = %count
@onready var item_display:RControl = %item_display

var current_slot := -1
var stack := 0
var grabbed := false
var item_texture:ItemTexture
var shadow:ItemTexture

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
	#Shadow_first
	shadow = _texture.duplicate()
	item_display.add_child.call_deferred(shadow)
	shadow.position = Vector2(11,11)
	shadow.set_deferred("modulate", shadow_color)
	shadow.hide()
	#then item normal
	item_texture = _texture.duplicate()
	item_display.add_child.call_deferred(item_texture)
	item_texture.position = Vector2(10,10)

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
