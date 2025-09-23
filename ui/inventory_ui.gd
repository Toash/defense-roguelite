extends Control

# ui that connects to Inventory autoload through its signals.
# adds a bunch of slots
# 	adds itemslots as child of a slot if it is considered populated.

class_name InventoryUI

@export var slot_num := 60
@export var item_scene: PackedScene
@export var slot_scene: PackedScene

@export var inventory_theme: StyleBoxFlat
@export var hotbar_theme: StyleBoxFlat

@onready var slots: GridContainer = %Slots

var _slots: Array[Slot] = []
# var _items: Array[ItemUI] = []

# maps uid to slot index for quick lookups (when removing)
var _uid_to_slot_idx: Dictionary[String, int] = {}

func _ready() -> void:
	visible = false
	_add_slots()
	Inventory.item_instance_added.connect(_on_item_added)
	Inventory.item_instance_removed.connect(_on_item_removed)
	Inventory.item_instance_changed.connect(_on_item_changed)
	_refresh()

func toggle() -> void:
	visible = not visible
	if visible:
		_refresh()

func _add_slots() -> void:
	# clear slots 
	for child in slots.get_children():
		child.queue_free()
	
	_slots.clear()
	_uid_to_slot_idx.clear()

	# build the slots
	for i in slot_num:
		# var item:= item_scene.instantiate() as ItemUI
		var slot: Slot = slot_scene.instantiate() as Slot

		#highlight hotbar slots
		if i < Hotbar.num_slots:
			slot.add_theme_stylebox_override("panel", hotbar_theme)
			slot.set_number(i + 1)
		else:
			slot.add_theme_stylebox_override("panel", inventory_theme)


		slot.slot_index = i
		slot.clear_slot()
		slots.add_child.call_deferred(slot)
		_slots.append(slot)

	_refresh()

# clears ui inventory and restores item instances.
func _refresh() -> void:
	_uid_to_slot_idx.clear()
	for s in _slots:
		s.clear_slot()
	for inst: ItemInstance in Inventory.all_instances():
		var saved := Inventory.get_slot_index_from_uid(inst.uid)
		if saved != -1:
			_uid_to_slot_idx[inst.uid] = saved
			_slots[saved].set_slot_item(inst)
		else:
			print("woah there!! did not store slot of item.")
			_place_instance(inst)


func _place_instance(inst: ItemInstance) -> void:
	# stack with same item definition and respect max stack.
	var stack_idx := _find_stackable_slot(inst)
	if stack_idx != -1:
		_uid_to_slot_idx[inst.uid] = stack_idx
		# _slots[stack_idx].set_item_instance(inst)
		_slots[stack_idx].set_slot_item(inst)
		Inventory.move_item(inst.uid, stack_idx)
		return

	var empty_idx := _first_empty_slot()
	if empty_idx != -1:
		_uid_to_slot_idx[inst.uid] = empty_idx
		_slots[empty_idx].set_slot_item(inst)
		Inventory.move_item(inst.uid, empty_idx)
		return

	# no space 
	print("no space!")

# finds a stackable slot and returns its corresponding index.
# returns -1 if cannot find one.
func _find_stackable_slot(inst: ItemInstance) -> int:
	# stackazble if share same ItemData and room remains (from maxstack)
	var max_stack := inst.data.max_stack if "max_stack" in inst.data else 1
	if max_stack <= 1:
		max_stack = 1
	for i in _slots.size():
		var slot: Slot = _slots[i]
		if slot.inst == null: continue
		if slot.inst.data == inst.data:
			max_stack = slot.inst.data.max_stack if slot.inst.data and "max_stack" in slot.inst.data else 1
			if max_stack > 1 and slot.inst.quantity < max_stack:
				return slot.slot_index
	return -1


func _first_empty_slot() -> int:
	for i in _slots.size():
		if _slots[i].inst == null:
			return _slots[i].slot_index
	return -1


# Signal handlers
func _on_item_added(inst: ItemInstance) -> void:
	_place_instance(inst)

func _on_item_removed(uid: String) -> void:
	if not _uid_to_slot_idx.has(uid):
		# fallback
		_refresh()
		return

	var idx: int = _uid_to_slot_idx[uid]
	_uid_to_slot_idx.erase(uid)
	_slots[idx].clear_slot()

func _on_item_changed(inst: ItemInstance) -> void:
	# refresh
	if _uid_to_slot_idx.has(inst.uid):
		var index := _uid_to_slot_idx[inst.uid]
		_slots[index].set_item_instance(inst)
	else:
		_place_instance(inst)
