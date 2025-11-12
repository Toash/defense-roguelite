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

# actual amount of instances
var size: int

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

func get_item_instance(i: int) -> ItemInstance:
	return _slot_to_inst.get(i, null)

func set_item_instance(i: int, inst: ItemInstance) -> void:
	_slot_to_inst[i] = inst
	if inst:
		_inst_uid_to_slot[inst.uid] = i
	else:
		self.size += 1
	ItemService.slot_changed.emit(self, i)


func remove_entirely(index: int) -> void:
	if _slot_to_inst[index]:
		self.size -= 1
		set_item_instance(index, null)
		ItemService.slot_changed.emit(self, index)

func remove_by(index: int, by: int) -> void:
	if _slot_to_inst[index]:
		var inst: ItemInstance = _slot_to_inst[index]
		inst.quantity -= by
		if inst.quantity <= 0:
			remove_entirely(index)
		ItemService.slot_changed.emit(self, index)


func get_index_by_uid(uid: String) -> int:
	return _inst_uid_to_slot[uid]

func get_first_empty_slot() -> int:
	for index in capacity:
		if _slot_to_inst.get(index, null) == null:
			return index
	return -1

## tries to give an index with the same instance that doesnt have max capacity.
## if not returns the first empty slot
## returns -1 if no slot is available.
# func get_available_slot_by_inst(compare_inst: ItemInstance) -> int:
# 	var first_empty_slot: int = -1

# 	for index in capacity:
# 		# try to merge first
# 		var inst = _slot_to_inst.get(index, null)
# 		if inst != null:
# 			if inst.quantity < inst.data.max_stack:
# 				return index
# 		else:
# 			# store first empty slot
# 			if first_empty_slot == -1:
# 				first_empty_slot = index
# 	return first_empty_slot


## max size
func get_capacity() -> int:
	return self.capacity

## number of items in container.
func get_size() -> int:
	return self.size


func is_empty() -> bool:
	return self.size == 0

func is_full() -> bool:
	return self.size == self.capacity


func get_item_instances() -> Array[ItemInstance]:
	return _slot_to_inst.values()

func sync_items(items: Array):
	_slot_to_inst.clear()
	for index in items.size():
		var inst: ItemInstance = items[index]
		_slot_to_inst[index] = inst


	for index in capacity:
		ItemService.slot_changed.emit(self, index)
