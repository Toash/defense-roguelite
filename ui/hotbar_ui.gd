extends Control

# the hotbar just mirrors a subset of the inventory.


@onready var slots := $Slots

@export var slot_scene: PackedScene

@export var hotbar_theme: StyleBoxFlat
@export var select_theme: StyleBoxFlat

var _selected_slot_idx: int = 0
var _slots: Array[Slot] = []

# Called when the node enters the scene tree for the first time.
# display slots that mirror the first x slots of the inventory.
func _ready() -> void:
	_add_slots()
	Inventory.item_instance_added.connect(_on_item_added)
	Inventory.item_instance_removed.connect(_on_item_removed)
	Inventory.item_instance_changed.connect(_on_item_changed)
	Inventory.item_instance_moved.connect(_on_item_moved)
	Hotbar.selected_slot_changed.connect(_on_selected_slot_changed)
	_refresh()
	_on_selected_slot_changed(Hotbar.selected_slot_index)

func _add_slots() -> void:
	for child in slots.get_children():
		child.queue_free()
	_slots.clear()

	for i in Hotbar.num_slots:
		var slot: Slot = slot_scene.instantiate() as Slot
		 
		slot.slot_index = i
		slot.clear_slot()
		slot.droppable = false
		slot.add_theme_stylebox_override("panel", hotbar_theme)
		slot.set_number(i + 1)

		slots.add_child.call_deferred(slot)
		_slots.append(slot)
	
func _refresh() -> void:
	for s in _slots:
		s.clear_slot()
	for inst: ItemInstance in Inventory.all_instances():
		var idx := Inventory.get_slot_index_from_uid(inst.uid)
		if idx >= 0 and idx < Hotbar.num_slots:
			_slots[idx].set_slot_item(inst, false)


func _on_item_added(inst: ItemInstance) -> void:
	_refresh()
func _on_item_removed(uid: String) -> void:
	_refresh()
func _on_item_changed(inst: ItemInstance) -> void:
	_refresh()
func _on_item_moved(uid: String, to_index: int) -> void:
	_refresh()

func _on_selected_slot_changed(idx: int):
	_slots[_selected_slot_idx].add_theme_stylebox_override("panel", hotbar_theme)
	_slots[idx].add_theme_stylebox_override("panel", select_theme)
	_selected_slot_idx = idx
