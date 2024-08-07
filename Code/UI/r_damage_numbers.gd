class_name DamageNumbersUi extends RDungeonUiElement

const DMG_NMB_LABEL = preload("res://Scenes/UI/dmg_nmb_label.tscn")
const MAGICAL = preload("res://Data/UI/dmg_numbers/magical.tres")
const PHYSICAL = preload("res://Data/UI/dmg_numbers/physical.tres")

var dmg_nmg:RRichTextLabel
var pool := []

func _ready():
	super()
	Signals.DmgNmbRepool.connect(_repool)
	Signals.DisplayDmgNumber.connect(_display_number)
	ui_ready = true

func _display_number(_value:= 0.0, _type:Array[Damage.TYPE] = [], _is_critical := false, _point:Marker2D = null):
	var nmb:DamageNumber = _get_number()
	_point.add_child(nmb)
	var _data = PHYSICAL
	if Damage.TYPE.MAGICAL in _type: _data = MAGICAL
	var text = "[center]" + str(_value) + "[/center]"
	nmb.text = text
	nmb.global_position = _point.global_position
	nmb.global_position.x -= nmb.size.x/2
	nmb.global_position.y -= nmb.size.y
	nmb.set_new_data(_data, _is_critical)
	nmb.start_display()

func _get_number() -> DamageNumber:
	if pool.is_empty():
		return DMG_NMB_LABEL.instantiate()
	else:
		return pool.pop_front()

func _repool(_dmg_nmb:DamageNumber = null):
	if _dmg_nmb:
		_dmg_nmb.get_parent().remove_child(_dmg_nmb)
		pool.append(_dmg_nmb)
