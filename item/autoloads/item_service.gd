extends Node

# ItemService
# handles items for all types of containers.
# single source of truth that handles moving, stacking, swap for containers.
#      emits signals for UIs to redraw.
# also other item stuff

signal slot_changed(container: ContainerName, index: int)

# resizing
# signal container_range_changed(container_id: String, start: int, end: int)

enum ContainerName {INVENTORY, HOTBAR, PICKUPS}

# all of these containers have the same operations.
var containers: Dictionary[ContainerName, ItemContainer] = {
	ContainerName.INVENTORY: InventoryContainer.new(40, ContainerName.INVENTORY),
	ContainerName.HOTBAR: HotbarContainer.new(8, ContainerName.HOTBAR),
	ContainerName.PICKUPS: PickupsContainer.new(16, ContainerName.PICKUPS)
}


func create_instance(data: ItemData, qty: int) -> ItemInstance:
	print("Item Service: Creating item instance for " + str(data.display_name))
	var inst := ItemInstance.new(data, qty)
	return inst


func save() -> Dictionary:
	return {
		"save_type": SaveManager.SaveType.NO_RELOAD,
		SaveManager.SaveKeys_NO_RELOAD.PATH: get_path(),

		"inventory": containers[ContainerName.INVENTORY].get_dict(),
		"hotbar": containers[ContainerName.HOTBAR].get_dict(),
		"pickups": containers[ContainerName.PICKUPS].get_dict(),
	}

func load(dict: Dictionary):
	var inventory: ItemContainer = containers[ContainerName.INVENTORY]
	var hotbar: ItemContainer = containers[ContainerName.HOTBAR]
	var pickups: ItemContainer = containers[ContainerName.PICKUPS]

	print(dict.inventory)

	inventory.load_dict(dict.inventory)
	hotbar.load_dict(dict.hotbar)
	pickups.load_dict(dict.pickups)

	for idx in inventory.get_capacity():
		slot_changed.emit(ContainerName.INVENTORY, idx)
	for idx in hotbar.get_capacity():
		slot_changed.emit(ContainerName.HOTBAR, idx)
	for idx in pickups.get_capacity():
		slot_changed.emit(ContainerName.PICKUPS, idx)


# ---------- INVENTORIES ----------------


# shift click

## Swaps an item to the next best container.
func quick_swap(from_container: ContainerName, from_index: int):
	print("quick swap")
	var to_container: ContainerName = _get_best_swap_container(from_container)
	if from_container == to_container:
		print("ItemService: Best container is the same as the current container")
		return

	var to_index = containers[to_container].get_first_empty_slot()

	if to_index == -1:
		print("ItemService: No more space whe quick swapping.")
		return

	var player = get_tree().get_first_node_in_group("player") as Node2D
	move(from_container, from_index, to_container, to_index, player)
	
	
func capacity(container: ContainerName) -> int:
	return containers[container].get_capacity()
	

func move(from_container: ContainerName, from_index: int, to_container: ContainerName, to_index: int, player: Node2D):
	print("moving item...")
	var src: ItemContainer = containers[from_container]
	var dst: ItemContainer = containers[to_container]


	# check if we picked up an item from the ground (pickup container -> whatever container)
	var from_item: ItemInstance = null
	if from_container == ContainerName.PICKUPS and to_container != ContainerName.PICKUPS:
		var inst: ItemInstance = src.get_item(from_index)
		from_item = GroundItems.take(inst.uid) # delete ground item before we put it into the other container.
		if from_item == null:
			push_error("Ground item doesnt exist")
	else:
		from_item = src.get_item(from_index)
	if from_item == null: return

	var to_item: ItemInstance = dst.get_item(to_index)

	# check if we are dropping an item (whatever container -> pickup container)
	if from_container != ContainerName.PICKUPS and to_container == ContainerName.PICKUPS:
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
				src.remove(from_index)
				slot_changed.emit(from_container, from_index)
			else:
				src.set_item(from_index, from_item)
				slot_changed.emit(from_container, from_index)
			dst.set_item(to_index, to_item)
			slot_changed.emit(to_container, to_index)
			return

	#swap
	src.set_item(from_index, to_item)
	dst.set_item(to_index, from_item)
	# slot_changed.emit(from_container, from_index)
	# slot_changed.emit(to_container, to_index)


func add_inst(container: ContainerName, added_inst: ItemInstance) -> bool:
	var cont := containers[container]

	# try stacking with exisiting item
	for i in cont.get_capacity():
		var curr_inst = cont.get_item(i)
		if curr_inst and curr_inst.data.id == added_inst.data.id and curr_inst.data.max_stack > curr_inst.quantity:
			var space = curr_inst.data.max_stack - curr_inst.quantity
			var moved = min(space, added_inst.quantity)
			curr_inst.quantity += moved
			added_inst.quantity -= moved
			cont.set_item(i, curr_inst)
			slot_changed.emit(container, i)
			return true


	# try empty slot
	for i in cont.get_capacity():
		if cont.get_item(i) == null:
			cont.set_item(i, added_inst)
			slot_changed.emit(container, i)
			return true


	# no space in the container
	return false

func _get_best_swap_container(container: ContainerName) -> ContainerName:
	if container == ContainerName.PICKUPS:
		if not containers[ContainerName.HOTBAR].is_full():
			return ContainerName.HOTBAR
		elif not containers[ContainerName.INVENTORY].is_full():
			return ContainerName.INVENTORY
		else:
			return container

	if container == ContainerName.HOTBAR:
		if not containers[ContainerName.INVENTORY].is_full():
			return ContainerName.INVENTORY

	if container == ContainerName.INVENTORY:
		if not containers[ContainerName.HOTBAR].is_full():
			return ContainerName.HOTBAR

	return container
