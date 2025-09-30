extends Control
class_name ContainerUI

# Mirrors containers in ItemService

@export var container: ItemService.ContainerName
@export var slot_scene: PackedScene
@export var slots_root: Node
@export var format: SlotsFormat = SlotsFormat.BLANK
enum SlotsFormat {
	BLANK,
	ZEROBASED,
	ONEBASED
}
var _slots: Array[Slot] = []


func _ready():
	_build_slots()
	_connect_signals()
	_refresh()


func _build_slots():
	# clear slots_root 
	for child in slots_root.get_children():
		child.queue_free()
	
	_slots.clear()

	# build the slots_root
	for i in ItemService.size(container):
		# var item:= item_scene.instantiate() as ItemUI
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
	ItemService.slot_changed.connect(func(c: ItemService.ContainerName, idx: int):
		if c != container: return
		_draw_slot(idx)
		)


func _refresh():
	for i in ItemService.size(container):
		_draw_slot(i)

func _draw_slot(i: int):
	if i < 0 or i >= ItemService.size(container):
		return
	var inst := ItemService.containers[container].get_item(i)
	_slots[i].set_slot_item(inst)
