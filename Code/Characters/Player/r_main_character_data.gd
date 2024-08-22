class_name MainCharacterData extends RCharacterData

@export_group("Critical")
@export var crit_chance := 0.05
@export var crit_dmg := 0.25

@export_group("Dungeon Stats")
@export var evaluating := 1
@export var skinning := 1
@export var picking := 1

@export_group("Prep Stats")
@export var chopping := 1
@export var grilling := 1
@export var stewing := 1
@export var brewing := 1
@export var baking := 1

@export_group("luck")
@export var luck:float = 0.0

@export_group("Gear")
@export var helmet:GearData
@export var chest:GearData
@export var pants:GearData
@export var acc1:GearData
@export var acc2:GearData
@export var weapon:WeaponData

func setup_data(_name := "") -> void:
	#Debug.log("setup data in main character data")
	id += _name
	_setup_gear()
	setup_starting_hp()
	current_lives = starting_life_count + _get_gear_stat("extra_life")
	Signals.DataSetupDone.emit()
	
func _setup_gear() -> void:
	if PlayerData.data.helmet != "":
		helmet = load(PlayerData.data.helmet)
	if PlayerData.data.chest != "":
		chest = load(PlayerData.data.chest)
	if PlayerData.data.pants != "":
		pants = load(PlayerData.data.pants)
	if PlayerData.data.acc1 != "":
		acc1 = load(PlayerData.data.acc1)
	if PlayerData.data.acc2 != "":
		acc2 = load(PlayerData.data.acc2)
	if PlayerData.data.weapon != "":
		weapon = load(PlayerData.data.weapon)

func _get_gear_stat(_id := "") -> float:
	var value = 0.0
	if helmet != null:
		value += helmet.get_value(_id)
	if chest != null:
		value += chest.get_value(_id)
	if pants != null:
		value += pants.get_value(_id)
	if acc1 != null:
		value += acc1.get_value(_id)
	if acc2 != null:
		value += acc2.get_value(_id)
	if weapon != null:
		value += weapon.get_value(_id)
	return value

func update_gear(_type := GM.GEARTYPE.HELMET, _gear_data:GearData = null, _acc_slot := 1) -> GearData:
	var old:GearData = null
	match _type:
		GM.GEARTYPE.HELMET:
			if helmet != null: old = helmet
			helmet = _gear_data
		GM.GEARTYPE.CHEST:
			if chest != null: old = chest
			chest = _gear_data
		GM.GEARTYPE.PANTS:
			if pants != null: old = pants
			pants = _gear_data
		GM.GEARTYPE.ACCESSORY:
			if _acc_slot == 1:
				if acc1 != null: old = acc1
				acc1 = _gear_data
			else:
				if acc2 != null: old = acc2
				acc2 = _gear_data
		GM.GEARTYPE.WEAPON:
			if weapon != null: old = weapon
			weapon = _gear_data
		_:
			pass
	if old != null: Signals.UpdateGearSaveData.emit(_type, _gear_data, _acc_slot)
	return old
