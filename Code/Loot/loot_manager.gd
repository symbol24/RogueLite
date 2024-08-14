class_name LootManager extends Node2D

const LOOTABLE = preload("res://Scenes/Loot/lootable.tscn")
const ITEM_TEXTURE_COIN = preload("res://Scenes/Items/Textures/item_texture_coin.tscn")

@export var impulse_force := 200.0

func _ready():
	Signals.SpawnLoot.connect(_spawn_loot)

func _spawn_loot(_table:LootTable = null, _pos := Vector2.ZERO):
	if _table != null and _pos != Vector2.ZERO:
		var loot = _table.get_loot()
		Debug.log("loot:", loot)
		for item in loot:
			var new_loot = LOOTABLE.instantiate() as Lootable
			GM.world.add_child.call_deferred(new_loot)
			await new_loot.ready
			new_loot.name = "loot"
			new_loot.set_data(item)
			new_loot.global_position = _pos
			new_loot.apply_impulse(Vector2(randf_range(-0.5,0.5), -1).normalized() * impulse_force, Vector2.ZERO)
		
		var currencies := []
		if _table.has_method("get_currencies"):
			currencies = _table.get_currencies()
			
		for currency in currencies:
			for x in currency["amount"]:
				var new_coin = LOOTABLE.instantiate() as Lootable
				GM.world.add_child.call_deferred(new_coin)
				await new_coin.ready
				new_coin.name = "currency"
				new_coin.set_data(currency["currency"])
				new_coin.global_position = _pos
				new_coin.apply_impulse(Vector2(randf_range(-0.5,0.5), -1).normalized() * impulse_force, Vector2.ZERO)
