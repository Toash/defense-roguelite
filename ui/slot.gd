extends Panel

# represents a slot in an inventory,
class_name Slot

var inst: ItemInstance = null
@export var slot_index: int = -1
@export var item_scene: PackedScene

func add_item_instance(instance: ItemInstance):
	var item: ItemUI = item_scene.instantiate()
	item.set_item_instance(instance)
	add_child(item)
	inst = instance

func clear_slot() -> void:
	for child in get_children():
		child.queue_free()
	inst = null