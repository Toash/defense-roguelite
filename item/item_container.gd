extends RefCounted

# base class for containers.


class_name ItemContainer

var capacity: int

func _init(c: int):
	self.capacity = c

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