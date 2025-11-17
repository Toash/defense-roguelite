extends Node

# base class for containers.

## represents a general container in the game that holds items.
## Note: This should be a sibling to an interactable if in the world.
## intracontainer functionality goes here. 
class_name ItemContainer

@export var capacity: int = 0
@export var container_name: ItemService.ContainerName

# used to persist item positions in an inventory.
var _slot_to_inst: Dictionary[int, ItemInstance] = {}
var _inst_uid_to_slot: Dictionary[String, int] = {}


# serialize
func get_dict() -> Dictionary:
	# convert iteminstances to dictionary
	var dict: Dictionary[int, Dictionary] = {}
	for slot: int in _slot_to_inst:
		var inst: ItemInstance = _slot_to_inst[slot]
		
		if inst == null:
			continue

		var inst_dict: Dictionary = inst.to_dict()
		dict[int(slot)] = inst_dict
	return dict

# unserialize
func load_dict(dict: Dictionary):
	for slot in dict:
		var inst_dict = dict[slot]
		var inst: ItemInstance = ItemInstance.from_dict(inst_dict)

		if inst == null:
			continue

		_slot_to_inst[int(slot)] = inst

func get_item_instance(index: int) -> ItemInstance:
	return _slot_to_inst.get(index, null)

func set_item_instance(index: int, inst: ItemInstance) -> void:
	var prev: ItemInstance = _slot_to_inst.get(index, null)

	if prev != null:
		_inst_uid_to_slot.erase(prev.uid)

	if inst != null:
		_slot_to_inst[index] = inst
		_inst_uid_to_slot[inst.uid] = index
	else:
		_slot_to_inst.erase(index)
		
	ItemService.slot_changed.emit(self, index)

## tries to add the group; returns the amount **leftover** (0 = fully added).
func try_add_item_group(group: ItemDataGroup) -> int:
	var items_left: int = group.amount

	# 1) Fill existing stacks
	for index in capacity:
		if items_left == 0:
			return 0

		var inst: ItemInstance = _slot_to_inst.get(index, null)
		if inst != null and inst.data == group.item_data:
			var to_max_stack = inst.data.max_stack - inst.quantity
			if to_max_stack <= 0:
				continue

			var to_add = min(items_left, to_max_stack)
			inst.quantity += to_add
			items_left -= to_add
			set_item_instance(index, inst)

	# 2) Use empty slots
	for index in capacity:
		if items_left == 0:
			break

		if _slot_to_inst.get(index, null) == null:
			var to_add = min(items_left, group.item_data.max_stack)
			var new_inst := ItemInstance.new()
			new_inst.data = group.item_data
			new_inst.quantity = to_add
			set_item_instance(index, new_inst)
			items_left -= to_add

	return items_left

		
func remove_entirely(index: int) -> void:
	if _slot_to_inst.has(index):
		set_item_instance(index, null)

func remove_by(index: int, by: int) -> void:
	var inst: ItemInstance = _slot_to_inst.get(index, null)
	if inst == null:
		return

	inst.quantity -= by
	if inst.quantity <= 0:
		set_item_instance(index, null)
	else:
		set_item_instance(index, inst)

## returns true if the container has enough items to accommodate the group, else false.
func has_enough_items(group: ItemDataGroup):
	var counter := 0

	for index in capacity:
		if _slot_to_inst[index]:
			var inst: ItemInstance = _slot_to_inst[index]
			if inst.data == group.item_data:
				counter += inst.quantity

	return counter >= group.amount


## take item instance in the container by an index an amount 
func take_as_much(index: int, by: int) -> ItemDataGroup:
	var inst: ItemInstance = _slot_to_inst.get(index, null)
	if inst == null:
		return null

	var amount_taken := min(inst.quantity, by)
	inst.quantity -= amount_taken

	if inst.quantity <= 0:
		set_item_instance(index, null)
	else:
		set_item_instance(index, inst)

	return ItemDataGroup.create(inst.data, amount_taken)


func get_index_by_uid(uid: String) -> int:
	return _inst_uid_to_slot[uid]

func get_first_empty_slot() -> int:
	for index in capacity:
		if _slot_to_inst.get(index, null) == null:
			return index
	return -1


func get_best_slot(item_data: ItemData):
	# scan for stackable else just first empty slot
	var first_empty_slot: int = -1

	for index in capacity:
		var inst = _slot_to_inst.get(index, null)
		if inst != null:
			if inst.data == item_data:
				var max_stack: int = inst.data.max_stack
				var current_stack: int = inst.quantity

				if current_stack < max_stack:
					return index
		elif first_empty_slot == -1:
			first_empty_slot = index
			

	return first_empty_slot


func get_slot_which_contains_item(item_data: ItemData):
	for index in capacity:
		var inst = _slot_to_inst.get(index, null)
		if inst != null:
			if inst.data == item_data:
				return index
			
	return -1


## max size
func get_capacity() -> int:
	return self.capacity

## number of items in container.
func get_size() -> int:
	# return self.size
	var count := 0
	for i in capacity:
		if _slot_to_inst.get(i, null) != null:
			count += 1
	return count


func is_empty() -> bool:
	# return self.size == 0
	return get_size() == 0

func is_full() -> bool:
	# return self.size == self.capacity
	return get_size() == capacity


func get_item_instances() -> Array[ItemInstance]:
	return _slot_to_inst.values()

func sync_items(items: Array):
	_slot_to_inst.clear()
	for index in items.size():
		var inst: ItemInstance = items[index]
		_slot_to_inst[index] = inst


	for index in capacity:
		ItemService.slot_changed.emit(self, index)
