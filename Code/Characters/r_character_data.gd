class_name RCharacterData extends Resource

@export var id := ""

@export_subgroup("Movement")
@export var speed:float = 100
@export var jump_height:float = 100
@export var jump_count:int = 1
@export var acceleration := 700
@export var friction := 1100
@export var air_multiplier := 0.6

@export_subgroup("Health")
@export var base_hp:float = 100
@export var starting_life_count:int = 1

@export_subgroup("attack")
@export var physical:float = 1.0
@export var magic:float = 1.0

@export_subgroup("Defence")
@export var base_armor:float = 1
@export var magic_resist:float = 0.0

var current_hp:float = 0.0:
	set(value):
		var pre = current_hp
		current_hp = value
		if current_hp < 0:
			current_hp = 0
		elif current_hp > max_hp:
			current_hp = max_hp
		#Debug.log(id, " character hp updated with ", current_hp - pre, " hp.")
		Signals.HPUpdated.emit(self, current_hp - pre)
		if current_hp == 0: 
			Signals.CharacterDead.emit(self)
			current_lives -= 1

var max_hp:float = 100:
	set(value):
		var pre = max_hp
		max_hp = value
		Signals.MaxHPUpdated.emit(self, max_hp)
		current_hp += max_hp - pre
		
var percent_hp:
	get:
		return roundf((current_hp / max_hp) * 100)
		
var current_lives:int = 1:
	set(value):
		current_lives = value
		if current_lives == 0:
			Signals.CharacterNoMoreLive.emit(self)

func setup_data(_name := ""):
	id += _name
	setup_starting_hp()
	current_lives = starting_life_count

func setup_starting_hp():
	current_hp = base_hp
	max_hp = base_hp

func update_hp(_value := 0.0):
	current_hp += _value

func apply_damage(_damage:Damage):
	var final_damage = _damage.base_value * _damage.crit_damage
	for type in _damage.types:
		match type:
			Damage.TYPE.PHYSICAL:
				final_damage -= base_armor
			Damage.TYPE.MAGICAL:
				final_damage -= final_damage * magic_resist
		if final_damage < 0.0: final_damage = 0.0
	current_hp -= final_damage
