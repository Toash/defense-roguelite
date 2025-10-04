extends Node

# Ground Items - Manager for items on the ground.

# uses itemdata to spawn corresponding instances.

@export var item_drop_scene: PackedScene = preload("res://item/ground_item.tscn")
var _uid_to_ground_item: Dictionary[String, GroundItem]


func spawn(data: ItemData, qty := 1, pos := Vector2.ZERO) -> Node2D:
	print("ItemFactory: Spawning " + data.display_name)
	if data == null:
		push_error("Could not find item data when spawning ground item.")
		return null
	
	# var inst := ItemInstance.new(data, qty)
	var inst: ItemInstance = ItemService.create_instance(data, qty)
	var pickup: GroundItem = item_drop_scene.instantiate()
	pickup.inst = inst
	pickup.global_position = pos
	_uid_to_ground_item[inst.uid] = pickup
	get_tree().current_scene.add_child.call_deferred(pickup)
	return pickup


# remove the itemdrop from the world and return its instance.
func take(item_uid: String) -> ItemInstance:
	print("picking up item...")
	if not _uid_to_ground_item.has(item_uid): return null

	var inst := _uid_to_ground_item[item_uid].inst
	_uid_to_ground_item[item_uid].queue_free()
	_uid_to_ground_item.erase(item_uid)
	return inst
