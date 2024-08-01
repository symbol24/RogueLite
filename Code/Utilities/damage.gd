class_name Damage extends Resource

enum TYPE {PHYSICAL, MAGICAL}

@export var id := ""
@export var base_value:float = 0
@export var type:TYPE = TYPE.PHYSICAL

var damage_owner:RCharacter:
	get:
		if damage_owner == null:
			Debug.error(id, " damage data is missing damage owner")
		return damage_owner
	set(_value):
		if _value:
			damage_owner = _value
			if damage_owner.data is MainCharacterData:
				owner_cc = damage_owner.data.crit_chance
				owner_cd = damage_owner.data.crit_dmg
		else:
			Debug.error("Attempting to assign a null value to damage owner of damage data of ", id)
var owner_cc := 0.0
var owner_cd := 0.0:
	get:
		var to_add := 0.0
		if owner_cc > 1.0:
			var over = owner_cc - 1.0
			to_add += over*0.3
		return 1.0 + owner_cd + to_add
var is_critical := false:
	get:
		var check:float = GM.rng.randf_range(0,1)
		if check <= owner_cc:
			return true
		return false
