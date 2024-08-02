class_name Damage extends Resource

enum TYPE {PHYSICAL, MAGICAL}

@export var id := ""
@export var base_value:float = 0
@export var types:Array[TYPE] = [TYPE.PHYSICAL]

var damage_owner:RCharacter:
	get:
		if damage_owner == null:
			Debug.error(id, " damage data is missing damage owner")
		return damage_owner
	set(_value):
		if _value:
			damage_owner = _value
			if damage_owner.data is MainCharacterData:
				crit_chance += damage_owner.data.crit_chance
				crit_damage += damage_owner.data.crit_dmg
		else:
			Debug.error("Attempting to assign a null value to damage owner of damage data of ", id)
var crit_chance := 0.0
var crit_damage := 0.0:
	get:
		var to_add := 0.0
		if crit_chance > 1.0:
			var over = crit_chance - 1.0
			to_add += over*0.3
		if is_critical:
			return 1.0 + crit_damage + to_add
		return 1.0
var is_critical := false:
	get:
		var check:float = GM.rng.randf_range(0,1)
		if check <= crit_chance:
			return true
		return false
