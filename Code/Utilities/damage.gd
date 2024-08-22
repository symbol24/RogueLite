class_name Damage extends Resource

enum TYPE {PHYSICAL, MAGICAL}

@export var id := ""
@export var base_value:float = 0
@export var types:Array[TYPE] = [TYPE.PHYSICAL]

@export var crit_chance := 0.0
@export var crit_damage := 0.0

var final_damage := 0.0
var is_critical := false
var critical_damage_multiplier := 0.0

var damage_owner:RCharacter:
	get:
		if damage_owner == null:
			Debug.error(id, " damage data is missing damage owner")
		return damage_owner
	set(_value):
		if _value: damage_owner = _value
		else: Debug.error("Attempting to assign a null value to damage owner of damage data of ", id)

func get_damage() -> Damage:
	var _result = _check_crit()
	var dmg_plus := 0.0
	if TYPE.PHYSICAL in types:
		dmg_plus += damage_owner.data.get_stat("physical")
	if TYPE.MAGICAL in types:
		dmg_plus += damage_owner.data.get_stat("magical")
	final_damage = (base_value + dmg_plus) * (1+critical_damage_multiplier)
	return self

func _check_crit() -> Dictionary:
	var to_return := {}
	var _is_crit := false
	var _crit_dmg := 0.0
	if damage_owner and damage_owner.data is MainCharacterData:
		var cc = crit_chance + damage_owner.data.get_stat("crit_chance")
		var cd = crit_damage + damage_owner.data.get_stat("crit_dmg")
		
		var check = GM.rng.randf_range(0,1)
		var over := 0.0
		if cc > 1.0:
			over = (cc - 1.0) * 0.3
		if check <= cc:
			_is_crit = true
			_crit_dmg = cd + over
	
	to_return = {"is_crit":_is_crit,
				"crit_dmg_mult":_crit_dmg}
	
	is_critical = _is_crit
	critical_damage_multiplier = _crit_dmg
	
	return to_return
