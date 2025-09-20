extends Control

# ui that connects to Inventory autoload through its signals.

class_name InventoryUI

@export var slot_count := 32
@export var slot_scene: PackedScene
@onready var grid: GridContainer = %Slots

var _slots: Array[ItemSlot] = []

# maps uid to slot index for quick lookups
var _uid_to_slot_idx: Dictionary[String, int] = {}

func _ready() -> void:
	visible = false
	_build_grid()
	Inventory.item_instance_added.connect(_on_item_added)
	Inventory.item_instance_removed.connect(_on_item_removed)
	Inventory.item_instance_changed.connect(_on_item_changed)
	_full_refresh()

func toggle() -> void:
	print("toggling inventory")
	visible = not visible
	if visible:
		_full_refresh()

func _build_grid() -> void:
	# clear slots 
	for child in grid.get_children():
		child.queue_free()
	_slots.clear()
	_uid_to_slot_idx.clear()

	# build the slots
	for i in slot_count:
		var slot := slot_scene.instantiate() as ItemSlot
		slot.slot_index = i
		slot.clear_slot()
		grid.add_child.call_deferred(slot)
		_slots.append(slot)

# clears ui inventory and restores item instances.
func _full_refresh() -> void:
	_uid_to_slot_idx.clear()
	for s in _slots:
		s.clear_slot()
	for inst: ItemInstance in Inventory.all_instances():
		_place_instance(inst)

func _place_instance(inst: ItemInstance) -> void:
	# if already placed, refresh the quantity.
	# is this needed?
	# if _uid_to_slot_idx.has(inst.uid):
	# 	var idx: int = _uid_to_slot_idx[inst.uid]
	# 	_slots[idx].set_item(inst)
	# 	return
	# stack with same item definition and respect max stack.
	var stack_idx := _find_stackable_slot(inst)
	if stack_idx != -1:
		_uid_to_slot_idx[inst.uid] = stack_idx
		_slots[stack_idx].set_iteminstance(inst)
		return

	var empty_idx := _first_empty_slot()
	if empty_idx != -1:
		_uid_to_slot_idx[inst.uid] = empty_idx
		_slots[empty_idx].set_iteminstance(inst)
		return

	# no space 
	print("no space!")

# finds a stackable slot and returns its corresponding index.
# returns -1 if cannot find one.
func _find_stackable_slot(inst: ItemInstance) -> int:
	# stackazble if share same ItemData and room remains (from maxstack)
	var max_stack := inst.data.max_stack if "max_stack" in inst.data else 1
	if max_stack <= 1:
		return 1
	for i in _slots.size():
		var slot: ItemSlot = _slots[i]
		if slot.inst == null: continue
		if slot.inst.data == inst.data:
			max_stack = slot.inst.data.max_stack if slot.inst.data and "max_stack" in slot.inst.data else 1
			if max_stack > 1 and slot.inst.quantity < max_stack:
				return i
	return -1


func _first_empty_slot() -> int:
	for i in _slots.size():
		if _slots[i].inst == null:
			return i
	return -1


# Signal handlers
func _on_item_added(inst: ItemInstance) -> void:
	_place_instance(inst)

func _on_item_removed(uid: String) -> void:
	if not _uid_to_slot_idx.has(uid):
		# fallback
		_full_refresh()
		return

	var idx: int = _uid_to_slot_idx[uid]
	_uid_to_slot_idx.erase(uid)
	_slots[idx].clear_slot()

func _on_item_changed(inst: ItemInstance) -> void:
	# refresh
	if _uid_to_slot_idx.has(inst.uid):
		var index := _uid_to_slot_idx[inst.uid]
		_slots[index].set_iteminstance(inst)
	else:
		_place_instance(inst)
