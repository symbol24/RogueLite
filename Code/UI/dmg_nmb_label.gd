class_name DamageNumber extends RichTextLabel

@export var data:DamageNumberData

var vert = 0.0
var visible_delay = 0.0

func _ready() -> void:
	hide()
	modulate = Color.TRANSPARENT

func set_new_data(_data:DamageNumberData, _is_critical := false):
	if _data:
		data = data
	
	if _is_critical: 
		set_theme(data.critical_theme)
		vert = data.critical_vertical
		visible_delay = data.critical_delay
	else: 
		set_theme(data.normal_theme)
		vert = data.normal_vertical
		visible_delay = data.normal_delay

func start_display() -> void:
	show()
	if modulate != Color.TRANSPARENT:
		modulate = Color.TRANSPARENT
	
	var tw1 = get_tree().create_tween()
	var tw2 = get_tree().create_tween()
	
	tw1.parallel().tween_property(self, "modulate", Color.WHITE,visible_delay)
	tw2.parallel().tween_property(self, "position", Vector2(position.x, position.y-vert), visible_delay)
	await tw1.finished
	hide()
	Signals.DmgNmbRepool.emit(self)
