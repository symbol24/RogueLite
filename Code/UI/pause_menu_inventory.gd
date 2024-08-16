class_name PauseMenuInventory extends SubPauseMenu

const INVENTORY_PAGE = preload("res://Scenes/UI/inventory_page.tscn")

@onready var inventory_tab_container:TabContainer = %inventory_tab_container
@onready var inventory_tabs:InventoryTabs = %inventory_tabs

var pages := []
var current_tab := 0:
	set(_value):
		current_tab = _value
		if current_tab >= inventory_tab_container.get_tab_count(): current_tab = 0
		elif current_tab < 0: current_tab = inventory_tab_container.get_tab_count()-1
		inventory_tab_container.set_deferred("current_tab", current_tab)
		_grab_inventory_focus(current_tab)
		Signals.PauseMenuInventoryToggleDot.emit(current_tab)
		#Debug.log("Invetory page is ", current_tab)
var active_slot:InventorySquare
var item_grabbed:InventoryDisplayItem

var character:MainCharacterData = null
var manager:ItemManager = null

func _ready():
	super()
	Signals.GrabInventoryFocus.connect(_grab_inventory_focus)
	Signals.CharacterSet.connect(_set_character_or_manager)
	Signals.ItemManagerIsSet.connect(_set_character_or_manager)
	Signals.ActiveInventorySquare.connect(_set_active_slot)
	Signals.MoveItemToNewParent.connect(_move_item)
	Signals.AdditemToInventoryUi.connect(_add_item_to_inventory_ui)
	Signals.UpdateCountOfitemInUi.connect(_update_count)

func _process(_delta):
	if in_focus:
		if RInput.ui_sub_tab_left:
			current_tab -= 1
		elif RInput.ui_sub_tab_right:
			current_tab += 1
		elif RInput.ui_x:
			_grab()
		elif RInput.ui_mouse_left:
			_grab()

func _grab():
	if active_slot != null:
		#Debug.log("active_slot ", active_slot)
		if item_grabbed == null: 
			item_grabbed = active_slot.grab()
			if item_grabbed != null: Debug.log(item_grabbed.name, " grabbed")
			else: Debug.log("No item to grab.")
		else:
			if item_grabbed != null:
				#Debug.log("Releasing item ", item_grabbed.name, " in slot ", active_slot.name)
				active_slot.release(item_grabbed)
				item_grabbed = null

func _build_inventory_pages(_character):
	if pages.is_empty():
		#Debug.log("PlayerData.data.inventory_page_count ", PlayerData.data.inventory_page_count)
		var inve_size = PlayerData.data.inventory_size
		for x in PlayerData.data.inventory_page_count:
			#Debug.log("Page ", x, " has inve_size of ", inve_size)
			var page = INVENTORY_PAGE.instantiate()
			inventory_tab_container.add_child.call_deferred(page)
			await page.ready
			page.name = "inventory_page_" + str(x)
			page.build_grid(x, inve_size)
			pages.append(page)
			if inve_size > 16: inve_size -= 16
		Signals.InventoryPagesDone.emit()
		_fill_items(manager)
		
		if pages.size() > 1: 
			inventory_tabs.show()
			inventory_tabs.add_dots(pages.size())
		else: inventory_tabs.hide()

func _fill_items(_manager:ItemManager):
	if _manager != null:
		var x := 0
		for page in pages:
			page.fill_items(PlayerData.data.inventory, x)
			x += 1

func _grab_inventory_focus(_tab := current_tab):
	if !pages.is_empty():
		pages[_tab].grab_first_focus()

func _set_active_slot(_value:InventorySquare = null):
	if _value != null:
		active_slot = _value

func _move_item(_item:InventoryDisplayItem, _new_slot_id := -1):
	if _item != null and _new_slot_id != -1:
		var new_slot:InventorySquare
		for page in pages:
			var temp = page.get_slot_by_id(_new_slot_id)
			if temp != null: new_slot = temp
		if new_slot != null:
			new_slot.add_item(_item)

func _add_item_to_inventory_ui(_dict := {}):
	var page = _get_page_from_slot_id(_dict["slot"])
	if page != null:
		page.add_item(_dict)

func _update_count(_dict := {}):
	var page = _get_page_from_slot_id(_dict["slot"])
	if page != null:
		var slot = page.get_slot_by_id(_dict["slot"])
		if slot.item != null:
			slot.item.set_stack(_dict["count"])

func _get_page_from_slot_id(_slot := -1) -> InventoryPage:
	if _slot > -1:
		for page in pages:
			for line in page.squares:
				for slot in line:
					if slot.get_meta("slot_id") == _slot:
						return page
		return null
	return null

func _set_character_or_manager(_value = null):
	if _value != null:
		if _value is MainCharacterData:
			character = _value
			#Debug.log("Set character: ", character.id)
		elif _value is ItemManager:
			manager = _value
			#Debug.log("Set manager: ", manager.name)
		
		if character != null and manager != null:
			_build_inventory_pages(character)
