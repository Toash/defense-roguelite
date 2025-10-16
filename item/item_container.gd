extends Node

# base class for containers.


class_name ItemContainer

var capacity: int
var size: int

# used to persist item positions in an inventory.
var _slot_to_inst: Dictionary[int, ItemInstance] = {}
var _inst_uid_to_slot: Dictionary[String, int] = {}

var container_name: ItemService.ContainerName

func _init(c: int, cname: ItemService.ContainerName):
	print("initializing container with name " + str(cname))
	self.capacity = c
	self.container_name = cname

# serialize
func get_dict() -> Dictionary:
	# convert iteminstances to dictionary
	var dict: Dictionary[int, Dictionary] = {}
	for slot: int in _slot_to_inst:
		var inst: ItemInstance = _slot_to_inst[slot]
		var inst_dict: Dictionary = inst.to_dict()
		dict[slot] = inst_dict
	return dict

# unserialize
func load_dict(dict: Dictionary):
	for slot in dict:
		var inst_dict = dict[slot]
		var inst: ItemInstance = ItemInstance.from_dict(inst_dict)
		_slot_to_inst[slot] = inst

func get_item(i: int) -> ItemInstance:
	return _slot_to_inst.get(i, null)

func set_item(i: int, inst: ItemInstance) -> void:
	if self.container_name == null: push_error("Container name not defined!")
	_slot_to_inst[i] = inst
	if inst:
		_inst_uid_to_slot[inst.uid] = i
	else:
		self.size += 1
	ItemService.slot_changed.emit(container_name, i)

func remove(i: int) -> void:
	if self.container_name == null: push_error("Container name not defined!")
	if _slot_to_inst[i]:
		self.size -= 1
		set_item(i, null)
		ItemService.slot_changed.emit(container_name, i)

func get_index_by_uid(uid: String) -> int:
	return _inst_uid_to_slot[uid]

func get_first_empty_slot() -> int:
	for index in ItemService.capacity(container_name):
		if _slot_to_inst.get(index, null) == null:
			return index
	return -1


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
