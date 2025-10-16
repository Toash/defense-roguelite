extends ItemContainer

class_name PickupsContainer


# Set the items in this container from the pickup detector.
func sync(items: Array):
	_slot_to_inst.clear()
	for index in items.size():
		var inst: ItemInstance = items[index]
		_slot_to_inst[index] = inst

	# emit signal - this is probably slow
	for index in ItemService.containers[ItemService.ContainerName.PICKUPS].size():
		ItemService.slot_changed.emit(ItemService.ContainerName.PICKUPS, index)


	# for slot in _slot_to_inst:
	# 	var inst: ItemInstance = _slot_to_inst[slot]
	# 	print(inst.data.display_name)

# func get_item(i: int) -> ItemInstance:
# 	return _slot_to_inst.get(i, null)

# func set_item(i: int, inst: ItemInstance) -> void:
# 	_slot_to_inst[i] = inst

# func remove(i: int) -> void:
# 	set_item(i, null)
