class_name LootManager extends Node2D

const LOOTABLE = preload("res://Scenes/Loot/lootable.tscn")
const ITEM_TEXTURE_COIN = preload("res://Scenes/Items/Textures/item_texture_coin.tscn")

@export var impulse_force := 200.0

func _ready():
	Signals.SpawnFromLootTable.connect(_spawn_loot)
	Signals.SpawnOneItem.connect(_spawn_one_item)

func _spawn_loot(_table:LootTable = null, _pos := Vector2.ZERO, _amount := 1):
	if _table != null and _pos != Vector2.ZERO:
		var loot = _table.get_loot(_amount)
		#Debug.log("loot:", loot)
		for item in loot:
			_spawn_one_item(item, _pos)
		
		var currencies := []
		if _table.has_method("get_currencies"):
			currencies = _table.get_currencies()
			
			for currency in currencies:
				for x in currency["amount"]:
					_spawn_one_item(currency["currency"], _pos)

func _spawn_one_item(_item:ItemData, _pos:=Vector2.ZERO) -> void:
	if _item != null and _pos != Vector2.ZERO:
		var new_loot = LOOTABLE.instantiate() as Lootable
		GM.world.add_child.call_deferred(new_loot)
		await new_loot.ready
		new_loot.name = _item.item_name
		new_loot.set_data(_item)
		new_loot.global_position = _pos
		new_loot.apply_impulse(Vector2(randf_range(-0.5,0.5), -1).normalized() * impulse_force, Vector2.ZERO)
