class_name InventoryPage extends RControl

const INVENTORY_SQUARE = preload("res://Scenes/UI/inventory_square.tscn")
const INVENTORY_DISPLAY_ITEM = preload("res://Scenes/Items/inventory_display_item.tscn")

const ROWS := 4
const COLUMNS := 4

@onready var grid:GridContainer = %grid

var grid_pos := Vector2i.ZERO:
	set(_value):
		grid_pos = _value
		if grid_pos.x >= squares.size(): grid_pos.x = 0
		elif grid_pos.x < 0: grid_pos.x = squares.size() - 1
		if grid_pos.y >= squares[0].size(): grid_pos.y = 0
		elif grid_pos.y < 0: grid_pos.x = squares[0].size() - 1
		#Debug.log("grid_pos ", grid_pos)
var squares:Array[Array] = []
var manager:ItemManager

func _ready() -> void:
	super()
	name = "inventory_page"
	if GM.item_manager != null: manager = GM.item_manager
	Signals.SetHoverOnSquare.connect(grab_hover_by_id)
	Signals.RemoveHoverOnSquare.connect(release_hover_by_id)

func build_grid(_page_id := 0, _square_amount := 0):
	#Debug.log("_page_id := ", _page_id, ", _square_amount := ", _square_amount)
	grid.columns = COLUMNS
	var slot_id := 0
	var square_count := _square_amount
	for x in ROWS:
		var line:Array = []
		for y in COLUMNS:
			var square = INVENTORY_SQUARE.instantiate()
			grid.add_child.call_deferred(square)
			#Debug.log("Setting slot_id: ", slot_id)
			square.set_meta("slot_id", slot_id)
			line.append(square)
			square.name = "square_" + str(_page_id) + "_" + str(x) + "_" + str(y)
			slot_id += 1
			if square_count <= 0:
				square.disable()
			square_count -= 1
		squares.append(line)

func fill_items(_items:Array, _page_id := 0) -> bool:
	if manager == null and GM.item_manager != null: manager = GM.item_manager
	if manager != null:
		if !squares.is_empty():
			for line in squares:
				for each in line:
					if each.item != null:
						each.remove_item()
		for item in _items:
			if item.has("slot") and item.has("item_id"):
				if item["slot"] >= (ROWS * COLUMNS * _page_id) and item["slot"] <= (ROWS * COLUMNS * (_page_id+1))-1:
					add_item(item)
		return true
	else: 
		Debug.warning("manager is still null!")
		return false
		

func get_slot_by_id(_slot_id := -1) -> InventorySquare:
	if _slot_id != -1:
		for line in squares:
			for square in line:
				if square.get_meta("slot_id") == _slot_id: return square
	Debug.error("No slot found with id: ", _slot_id)
	return null

func grab_first_focus() -> void:
	await visibility_changed
	squares[0][0].grab_focus()

func grab_hover_by_id(_slot_id := -1):
	if _slot_id != -1:
		var slot = get_slot_by_id(_slot_id)
		if slot != null: slot.mouse_entered.emit()

func release_hover_by_id(_slot_id := -1):
	if _slot_id != -1:
		var slot = get_slot_by_id(_slot_id)
		if slot != null: slot.mouse_exited.emit()
	
func add_item(_item := {}):
	if manager != null:
		var slot = get_slot_by_id(_item["slot"])
		var item_data = manager.get_item(_item["item_id"])
		var display_item = INVENTORY_DISPLAY_ITEM.instantiate() as InventoryDisplayItem
		slot.add_item.call_deferred(display_item)
		await display_item.ready
		display_item.set_display_item_name("display_item_"+str(_item["slot"]))
		display_item.set_stack(_item["count"])
		display_item.set_textures(item_data.texture.instantiate() as ItemTexture)
	else:
		Debug.error("Manager is null?")
