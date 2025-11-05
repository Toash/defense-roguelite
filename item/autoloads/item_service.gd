extends Node

# ItemService
# handles items for all types of player_containers.
# single source of truth that handles moving, stacking, swap for player_containers.
#      emits signals for UIs to redraw.
# also other item stuff

# signal slot_changed(container: ContainerName, index: int)
signal slot_changed(container: ItemContainer, index: int)

# resizing
# signal container_range_changed(container_id: String, start: int, end: int)

enum ContainerName {INVENTORY, HOTBAR, PICKUPS, WORLD}

# @export var player_inventory: Node
# @export var player_hotbar: Node
# @export var player_pickups: Node


# containers should be configured in-editor
# ensure the player is loaded before calling this function  - use Game.player_loaded signal
func get_player_container(container_name: ContainerName) -> ItemContainer:
	var player: Node = get_tree().get_first_node_in_group("player") as Node
	if player == null:
		push_error("Item Service: Could not find player node!")

	var containers: Node = player.get_node("Containers")
	if containers == null:
		push_error("Item Service: Could not find the containers node on the player!")

	if container_name == ContainerName.INVENTORY:
		var inventory := containers.get_node("Inventory")
		if inventory == null:
			push_error("Item Service: Could not find inventory node on the player!")
		return inventory as ItemContainer

	elif container_name == ContainerName.HOTBAR:
		var hotbar = containers.get_node("Hotbar")
		if hotbar == null:
			push_error("Item Service: Could not find hotbar node on the player!")
		return hotbar as ItemContainer

	elif container_name == ContainerName.PICKUPS:
		var pickups = containers.get_node("Pickups")
		if pickups == null:
			push_error("Item Service: Could not find pickups node on the player!")
		return pickups as ItemContainer
	else:
		push_error("Item_Service: Could not find player container")
		return null

func create_instance(data: ItemData, qty: int) -> ItemInstance:
	print("Item Service: Creating item instance for " + str(data.display_name))
	var inst := ItemInstance.new(data, qty)
	return inst


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.PATH: get_path(),


		"inventory": get_player_container(ContainerName.INVENTORY).get_dict(),
		"hotbar": get_player_container(ContainerName.HOTBAR).get_dict(),
		"pickups": get_player_container(ContainerName.PICKUPS).get_dict()

	}

func load(dict: Dictionary):
	var inventory: ItemContainer = get_player_container(ContainerName.INVENTORY)
	var hotbar: ItemContainer = get_player_container(ContainerName.HOTBAR)
	var pickups: ItemContainer = get_player_container(ContainerName.PICKUPS)

	inventory.load_dict(dict.inventory)
	hotbar.load_dict(dict.hotbar)
	pickups.load_dict(dict.pickups)

	for idx in inventory.get_capacity():
		slot_changed.emit(inventory, idx)
	for idx in hotbar.get_capacity():
		slot_changed.emit(hotbar, idx)
	for idx in pickups.get_capacity():
		slot_changed.emit(pickups, idx)


# ---------- INVENTORIES ----------------


func _process(delta):
	_update_item_state(ContainerName.HOTBAR, delta)

func _update_item_state(container: ContainerName, delta: float):
	# for inst in player_containers[container].get_item_instances():
	# 	inst.update_state(delta)
	for inst in get_player_container(container).get_item_instances():
		inst.update_state(delta)


# shift click

## Swaps an item to the next best container.
func quick_swap(from_container: ItemContainer, from_index: int):
	print("quick swap")
	var to_container_name: ContainerName = _get_best_swap_container_name(from_container.container_name)
	if from_container.container_name == to_container_name:
		print("ItemService: Best container is the same as the current container")
		return

	var to_index = get_player_container(to_container_name).get_first_empty_slot()

	if to_index == -1:
		print("ItemService: No more space whe quick swapping.")
		return

	var player = get_tree().get_first_node_in_group("player") as Node2D
	# move(from_container, from_index, to_container, to_index, player)

	var container_name: ItemContainer = get_player_container(to_container_name)
	# container will not be in the world
	move(from_container, from_index, container_name, to_index, player)
	
	
func move(from_container: ItemContainer, from_index: int, to_container: ItemContainer, to_index: int, player: Node2D):
	# check if we picked up an item from the ground (pickup container -> whatever container)
	var from_item: ItemInstance = null
	if from_container.container_name == ContainerName.PICKUPS and to_container.container_name != ContainerName.PICKUPS:
		var inst: ItemInstance = from_container.get_item(from_index)
		from_item = GroundItems.take(inst.uid) # delete ground item before we put it into the other container.
		if from_item == null:
			push_error("Ground item doesnt exist")
	else:
		from_item = from_container.get_item(from_index)
	if from_item == null: return

	var to_item: ItemInstance = to_container.get_item(to_index)

	# check if we are dropping an item (whatever container -> pickup container)
	if from_container.container_name != ContainerName.PICKUPS and to_container.container_name == ContainerName.PICKUPS:
		GroundItems.spawn_by_data(from_item.data, from_item.quantity, player.position)

	# merge
	if to_item and to_item.data.id == from_item.data.id and to_item.data.max_stack > 1:
		var space: int = to_item.data.max_stack - to_item.quantity
		if space > 0:
			var move_amount = min(space, from_item.quantity)
			if move_amount <= 0: return
			to_item.quantity += move_amount
			from_item.quantity -= move_amount

			if from_item.quantity <= 0:
				from_container.remove(from_index)
				slot_changed.emit(from_container, from_index)
			else:
				from_container.set_item(from_index, from_item)
				slot_changed.emit(from_container, from_index)
			to_container.set_item(to_index, to_item)
			slot_changed.emit(to_container, to_index)
			return

	#swap
	from_container.set_item(from_index, to_item)
	to_container.set_item(to_index, from_item)


func add_inst(container: ItemContainer, added_inst: ItemInstance) -> bool:
	# var cont := player_containers[container]
	# try stacking with exisiting item
	for i in container.get_capacity():
		var curr_inst = container.get_item(i)
		if curr_inst and curr_inst.data.id == added_inst.data.id and curr_inst.data.max_stack > curr_inst.quantity:
			var space = curr_inst.data.max_stack - curr_inst.quantity
			var moved = min(space, added_inst.quantity)
			curr_inst.quantity += moved
			added_inst.quantity -= moved
			container.set_item(i, curr_inst)
			slot_changed.emit(container, i)
			return true


	# try empty slot
	for i in container.get_capacity():
		if container.get_item(i) == null:
			container.set_item(i, added_inst)
			slot_changed.emit(container, i)
			return true


	# no space in the container
	return false

func _get_best_swap_container_name(container: ContainerName) -> ContainerName:
	if container == ContainerName.PICKUPS:
		if not get_player_container(ContainerName.HOTBAR).is_full():
			return ContainerName.HOTBAR
		elif not get_player_container(ContainerName.INVENTORY).is_full():
			return ContainerName.INVENTORY
		else:
			return container

	if container == ContainerName.HOTBAR:
		if not get_player_container(ContainerName.INVENTORY).is_full():
			return ContainerName.INVENTORY

	if container == ContainerName.INVENTORY:
		if not get_player_container(ContainerName.HOTBAR).is_full():
			return ContainerName.HOTBAR

	return container
