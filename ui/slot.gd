extends Panel


# dumb slot in container

class_name Slot

var inst: ItemInstance = null
@export var container: ItemService.ContainerName # inventory, hotbar, pickups
@export var slot_index: int = -1

@export var item_scene: PackedScene

# var droppable = true

@export var number_label: Label

@export var highlight: Control
var _selected = false

func set_slot_item(instance: ItemInstance, draggable = true):
	if instance == null:
		clear_slot()
		return

	var item: ItemUI = item_scene.instantiate()
	item.set_item_instance(instance)
	add_child(item)
	inst = instance

func set_selected(b: bool):
	# print(str(b))
	_selected = b
	if highlight:
		highlight.visible = b

func clear_slot() -> void:
	for child in get_children():
		if child is ItemUI:
			child.queue_free()
	inst = null

func set_number(number: int):
	number_label.text = str(number)


# can check for item size here
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("checking...")
	# if not droppable: return false
	return typeof(data) == TYPE_DICTIONARY and data.has("inst") and data.has("from_slot")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var from_inst: ItemInstance = data["inst"]

	var from_slot: Slot = data["from_slot"]
	var from_container: ItemService.ContainerName = from_slot.container
	var from_slot_index: int = from_slot.slot_index

	if !_can_drop_data(at_position, data):
		return

	# same slot.....
	if from_container == container and from_slot_index == slot_index:
		return


	ItemService.move(
		from_container, from_slot_index,
		container, slot_index,
		get_tree().get_first_node_in_group("player") # only the player will drop items on a slot

	)
