class_name InventorySquare extends RControl

@export var disabled_color:Color

@onready var background = %background
@onready var highlight = %highlight
@onready var hover = %hover

var item:InventoryDisplayItem
var is_disabled := false

func _ready():
	super()
	focus_entered.connect(_focus_entered)
	focus_exited.connect(_focus_exited)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func grab() -> InventoryDisplayItem:
	if !is_disabled and item != null: 
		var temp = item
		item = null
		return temp
	return null

func release(_item:InventoryDisplayItem = null):
	if item == null and _item != null:
		_item.get_parent().remove_child(_item)
		add_item(_item)
		#Debug.log("item ", _item, " released")
	elif item != null and _item != null:
		var temp = item
		item = null
		Signals.MoveItemToNewParent.emit(temp, _item.current_slot)
		add_item(_item)

func _focus_entered():
	Signals.ActiveInventorySquare.emit(self)
	highlight.show()

func _focus_exited():
	highlight.hide()

func _mouse_entered():
	hover.show()
	
func _mouse_exited():
	hover.hide()

func add_item(_item:InventoryDisplayItem):
	if _item and item == null:
		if _item.get_parent(): _item.get_parent().remove_child(_item)
		item = _item
		add_child.call_deferred(item)
		item.position = Vector2.ZERO
		item.set_slot(get_meta("slot_id"))

func remove_item():
	if item:
		remove_child.call_deferred(item)
		item.queue_free.call_deferred()
		item = null

func disable():
	is_disabled = true
	set_deferred("modulate", disabled_color)
	set_deferred("focus_mode", 0)
