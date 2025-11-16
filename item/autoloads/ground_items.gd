extends Node

# Ground Items - Autoload for items on the ground.

# uses itemdata to spawn_by_data corresponding instances.

@export var item_drop_scene: PackedScene = preload("res://item/ground_item.tscn")
var _uid_to_ground_item: Dictionary[String, GroundItem]


func spawn_by_data(data: ItemData, qty := 1, pos := Vector2.ZERO) -> Node2D:
	if data == null:
		push_error("Could not find item data when spawning ground item.")
		return null
	return _spawn(data, qty, pos)

func spawn_by_name(item_name: String, qty := 1, pos := Vector2.ZERO) -> Node2D:
	var data = ItemDatabase.get_from_display_name(item_name)
	if data == null:
		push_error("Could not find item data when spawning ground item.")
		return null
	return _spawn(data, qty, pos)

func spawn_by_name_on_player(item_name: String, qty := 1) -> Node2D:
	var data = ItemDatabase.get_from_display_name(item_name)
	if data == null:
		push_error("Could not find item data when spawning ground item.")
		return null

	# hacky
	var pos: Vector2 = get_tree().get_first_node_in_group("player").global_position
	return _spawn(data, qty, pos)

func spawn_by_id(id: int, qty := 1, pos := Vector2.ZERO) -> Node2D:
	var data = ItemDatabase.get_from_id(id)
	if data == null:
		push_error("Could not find item data when spawning ground item.")
		return null
	return _spawn(data, qty, pos)
	

func _spawn(data: ItemData, qty := 1, pos := Vector2.ZERO) -> Node2D:
	print("ItemFactory: Spawning " + data.display_name)
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

func clear():
	for uid in _uid_to_ground_item:
		(_uid_to_ground_item[uid] as Node2D).queue_free()
	
	_uid_to_ground_item.clear()

	# for ground_item in _uid_to_ground_item.values():
	# 	ground_item.queue_free()
