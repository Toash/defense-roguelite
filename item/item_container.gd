extends Node

# base class for containers.


class_name ItemContainer

var capacity: int

# used to persist item positions in an inventory.
# var _slot_to_inst: Dictionary[int, ItemInstance] = {}
var _slot_to_inst = {}

func _init(c: int):
	self.capacity = c

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
	push_error("Implement this")
	return null

func set_item(i: int, inst: ItemInstance) -> void:
	push_error("Implement this")
	return

func remove(i: int) -> void:
	push_error("Implement this")
	return

func size() -> int:
	return self.capacity
