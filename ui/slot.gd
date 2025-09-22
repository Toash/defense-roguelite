extends Panel

# represents a slot in an inventory,
# an item is in the inst variable as well as a child of this slot.

class_name Slot

var inst: ItemInstance = null
@export var slot_index: int = -1
@export var item_scene: PackedScene

func set_slot(instance: ItemInstance):
	var item: ItemUI = item_scene.instantiate()
	item.set_item_instance(instance)
	add_child(item)
	inst = instance

func clear_slot() -> void:
	for child in get_children():
		child.queue_free()
	inst = null

# can check for item size here
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("inst") and data.has("from_slot")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if !_can_drop_data(at_position, data):
		return

	var dropped_inst: ItemInstance = data["inst"]
	var from_slot: Slot = data["from_slot"]

	# same slot
	if from_slot == self:
		return

	# no item in slot
	if inst == null:
		set_slot(dropped_inst)
		from_slot.clear_slot()
		Inventory.clear_slot(dropped_inst.uid)
		Inventory.set_slot(dropped_inst.uid, slot_index)
		return

	# same item and is stackable
	if inst.data.id == dropped_inst.data.id and inst.data.max_stack > 1:
		var space: int = inst.data.max_stack - inst.quantity
		if space > 0:
			var to_move: int = min(space, dropped_inst.quantity)
			inst.quantity += to_move

			# refresh destination item ui
			(get_child(0) as ItemUI).set_item_instance(inst)

			dropped_inst.quantity -= to_move
			if dropped_inst.quantity <= 0:
				from_slot.clear_slot()
				Inventory.clear_slot(dropped_inst.uid)
			else:
				#refresh source item ui
				(from_slot.get_child(0) as ItemUI).set_item_instance(dropped_inst)
			return

	# no space, swap
	# different item or no stack space.
	var temp := inst
	clear_slot()
	set_slot(dropped_inst)

	from_slot.clear_slot()
	from_slot.set_slot(temp)

	Inventory.set_slot(dropped_inst.uid, slot_index)
	Inventory.set_slot(temp.uid, from_slot.slot_index)
