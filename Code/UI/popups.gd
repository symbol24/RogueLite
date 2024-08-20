class_name PopupManager extends RControl

enum TYPE {NORMAL, WARNING, ERROR, TEXT}

@export var warning_color:Color
@export var error_color:Color

#BIG POPUP
@onready var big_popup: Control = %big_popup
@onready var popup_title: RRichTextLabel = %popup_title
@onready var popup_text: RRichTextLabel = %popup_text
@onready var color_box: ColorRect = %color_box
@onready var confirm_text: RRichTextLabel = %confirm_text
@onready var a_button: Node2D = %A_button
var last_big_id := ""
var has_confirm := false

#TEXT ONLY POPUP
@onready var text_only_popup: Control = %text_only_popup
@onready var text_only_popup_text: RRichTextLabel = %text_only_popup_text

var big_pool := []
var text_pool := []

#text only display timer
var timer := 0.0
@export var delay := 5.0

#region ALL popup texts and titles will be here
var inventory_full := "Unable to pick up, inventory full."
#endregion

func _ready() -> void:
	super()
	Signals.DisplayPopup.connect(_pool_popups)

func _input(event: InputEvent) -> void:
	if RInput.is_focused_on_ui:
		if big_popup.is_visible():
			if event.is_action_pressed("ui_cancel"):
				Signals.PopupCancelled.emit(last_big_id)
				_hide_big_popup()
			elif has_confirm and RInput.ui_confirm:
				Signals.ConfirmPopup.emit(last_big_id)
				_hide_big_popup()
		
		if !big_popup.is_visible():
			if event.is_action_pressed("ui_select"):
				Signals.DisplayPopup.emit("help")
			if !big_pool.is_empty():
				var pop = big_pool.pop_front()
				_display_big_popup(pop["id"], pop["type"])

func _process(_delta: float) -> void:
	if is_visible() and !get_tree().is_paused():
		if text_only_popup.is_visible():
			timer += _delta
			if timer >= delay:
				_hide_text_popup()
	
	if !big_popup.is_visible():
		if !big_pool.is_empty():
			var pop = big_pool.pop_front()
			_display_big_popup(pop["id"], pop["type"])
	
	if !text_only_popup.is_visible() and !get_tree().is_paused():
		if !text_pool.is_empty():
			var _id = text_pool.pop_front()
			_display_text_only_popup(_id)

func _pool_popups(_id := "", _type := TYPE.NORMAL) -> void:
	match _type:
		TYPE.TEXT:
			text_pool.append(_id)
		_:
			big_pool.append({"id":_id, "type":_type})

func _display_big_popup(_id := "", _type := TYPE.NORMAL, _display_confirm := false) -> void:
	#Debug.log("Receiving DisplayBigPopup with id: ", _id)
	var title := "[center][b]"
	var text := ""
	
	match _id:
		"":
			title += "ERROR: No ID"
			text = "No id was passed to popup error."
		_:
			title += "ERROR: Wrong ID"
			text = "No id recognized for popup."
	
	title += "[/b][/center]"
	
	match _type:
		TYPE.WARNING:
			color_box.show()
			color_box.color = warning_color
		TYPE.ERROR:
			color_box.show()
			color_box.color = error_color
		_:
			color_box.hide()
	
	has_confirm = _display_confirm
	if has_confirm:
		confirm_text.show()
		a_button.show()
	else:
		confirm_text.hide()
		a_button.hide()
	
	popup_title.text = title
	popup_text.text = text
	Signals.ToggleUiFocus.emit(id)
	Signals.UpdateInputFocus.emit(RInput.FOCUS.UIFOCUS)
	if !GM.is_playing():
		Signals.TogglePause.emit(GM.PAUSETYPE.NOMENU)
	big_popup.show()
	show()

func _hide_big_popup() -> void:
	big_popup.hide()
	popup_title.text = ""
	popup_text.text = ""
	hide()
	Signals.ToggleUiFocus.emit(UI.previous_focus)
	Signals.UpdateInputFocus.emit(RInput.previous_focus)
	if !GM.is_paused_with_menu():
		Signals.TogglePause.emit(GM.PAUSETYPE.NOMENU)

func _display_text_only_popup(_id := "") -> void:
	#Debug.log("Receiving DisplayTextPopup with id: ", _id)
	var text := "[b]"
	
	match _id:
		"":
			text += "No id passed to popup."
		"inventory_full":
			text += inventory_full
		_:
			text += "No id recognized for popup."
			
	text += "[/b]"
	text_only_popup_text.text = text
	Signals.ToggleUiFocus.emit(id)
	text_only_popup.show()
	show()

func _hide_text_popup() -> void:
	text_only_popup.hide()
	timer = 0.0
	hide()
	Signals.ToggleUiFocus.emit(UI.previous_focus)
