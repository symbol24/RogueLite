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
@export var physical:float = 0.0
@export var magic:float = 0.0

@export_subgroup("Defence")
@export var base_armor:float = 0
@export var magic_resist:float = 0.0

var current_hp:float = 1.0:
	set(_value):
		#Debug.log(id, " updated current_hp with ", _value)
		var pre = current_hp
		current_hp = _value
		Signals.HPUpdated.emit(self, current_hp - pre)

var max_hp:float = 100:
	set(value):
		max_hp = value
		Signals.MaxHPUpdated.emit(self, max_hp)
		
var percent_hp:
	get:
		return roundf((current_hp / max_hp) * 100)

var is_dead := false
var current_lives:int = 1:
	set(value):
		current_lives = value
		if current_lives == 0:
			is_dead = true
			Signals.CharacterNoMoreLives.emit(self)

func setup_data(_name := ""):
	id += _name
	setup_starting_hp()
	current_lives = starting_life_count

func setup_starting_hp() -> void:
	#Debug.log(id, " starts with ", current_hp , "/", max_hp)
	#Debug.log(id, " has a base_hp of: ", base_hp)
	current_hp = base_hp
	max_hp = base_hp
	#Debug.log(id, " is now at ", current_hp , "/", max_hp)

func add_max_hp(_value := 0.0):
	var pre = max_hp
	max_hp += _value
	if current_hp == pre: current_hp = max_hp
	else: current_hp += max_hp - pre

func update_hp(_value := 0.0):
	var _pre = current_hp
	#Debug.log("Pre hp: ", pre)
	current_hp += _value
	if current_hp < 0:
		current_hp = 0
	elif current_hp > max_hp:
		current_hp = max_hp
	#Debug.log(id, " character hp updated with ", current_hp - pre, " hp. New HP: ", current_hp)
	if current_hp == 0: 
		Signals.CharacterDead.emit(self)
		current_lives -= 1

func apply_damage(_damage:Damage) -> float:
	var final_damage = _damage.final_damage
	for type in _damage.types:
		match type:
			Damage.TYPE.PHYSICAL:
				final_damage -= base_armor
			Damage.TYPE.MAGICAL:
				final_damage -= final_damage * magic_resist
		if final_damage < 0.0: final_damage = 0.0
	update_hp(-final_damage)
	return final_damage
