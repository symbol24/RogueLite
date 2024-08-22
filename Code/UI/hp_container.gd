extends RDungeonUiElement

@onready var hp_bar:TextureProgressBar = %hp_bar
@onready var hp_label:Label = %hp_label

var start_size := 0.0
var start_max := 0.0
var last_max := 0.0

func _ready() -> void:
	super()
	Signals.HPUpdated.connect(_update_hp)
	Signals.MaxHPUpdated.connect(_update_max_hp)
	Signals.CharacterSet.connect(_update_starting_max)
	start_size = hp_bar.size.x
	hp_label.position.x = (start_size - hp_label.size.x)/2
	
func _update_starting_max(_data:RCharacterData):
	if _data is MainCharacterData:
		#Debug.log("hp: ", _data.current_hp, "/", _data.max_hp)
		start_max = _data.max_hp
		last_max = _data.max_hp
		hp_bar.value = _data.percent_hp
		hp_label.text = str(_data.current_hp) + "/" + str(_data.max_hp)
		ui_ready = true
	
func _update_hp(_data:RCharacterData, _diff):
	if GM.character != null and _data.id == GM.character.data.id:
		hp_bar.value = _data.percent_hp
		hp_label.text = str(_data.current_hp) + "/" + str(_data.max_hp)

func _update_max_hp(_data:RCharacterData, _new_max):
	if GM.character != null and _data.id == GM.character.data.id:
		var diff = (_data.max_hp - last_max) / _data.max_hp
		hp_bar.size.x += start_size * diff
		hp_label.text = str(_data.current_hp) + "/" + str(_data.max_hp)
		hp_label.position.x = (hp_bar.size.x - hp_label.size.x)/2
		last_max = _data.max_hp
