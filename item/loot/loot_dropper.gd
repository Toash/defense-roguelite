extends Node2D

class_name LootDropper

@export var loot_table: LootTable


func drop_loot():
	var item_group: ItemDataGroup = loot_table.get_drop()
	GroundItems.spawn_item_group(item_group, global_position)
