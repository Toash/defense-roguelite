extends Control


## Displays the items in the container
class_name ContainerUI


@export var container: ItemContainer

@export var slot_scene: PackedScene

## the root node for the slots, typically a grid container.
@export var slots_root: Node

@export var format: SlotsFormat = SlotsFormat.BLANK
enum SlotsFormat {
	BLANK,
	ZEROBASED,
	ONEBASED
}
var _slots: Array[Slot] = []


func setup():
	# if container == null:
	# 	push_error("ContainerUI: Container should be defined.")
	_build_slots()
	_connect_signals()
	_refresh()

func _build_slots():
	# clear slots_root 
	for child in slots_root.get_children():
		child.queue_free()
	
	_slots.clear()

	# build the slots_root
	if container != null:
		for i in container.get_capacity():
			var slot: Slot = slot_scene.instantiate() as Slot

			slot.container = container
			if format == SlotsFormat.ZEROBASED:
				slot.set_number(i)
			if format == SlotsFormat.ONEBASED:
				slot.set_number(i + 1)
			slot.slot_index = i
			slot.clear_slot()

			slots_root.add_child.call_deferred(slot)
			_slots.append(slot)

	_refresh()

func _connect_signals():
	if container == null: return
	
	ItemService.slot_changed.connect(func(other: ItemContainer, idx: int):
		if other.container_name != container.container_name: return
		_draw_slot(idx)
		)


func _refresh():
	if container == null: return

	for i in container.get_capacity():
		_draw_slot(i)

func _draw_slot(i: int):
	if container == null: return

	if i < 0 or i >= container.get_capacity():
		return
	var inst: ItemInstance = container.get_item(i)
	_slots[i].set_slot_item(inst)
