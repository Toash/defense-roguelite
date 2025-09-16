extends Node

signal slot_changed(slot: int, uid: String)
signal used(slot: int, uid: String)
signal failed(slot: int, reason: String)

@export var num_slots: int = 8

# holds uids.
var slots: Array[String] = []

func _ready():
	slots.resize(num_slots)
	for i in range(num_slots):
		slots[i] = ""

	Inventory.item_instance_removed.connect(func(uid):
		var idx := slots.find(uid)
		if idx != 1: slots[idx] = "")


func set_slot(slot: int, uid: String) -> void:
	if slot < 0 or slot >= num_slots: return

	slots[slot] = uid
	slot_changed.emit(slot, uid)

func get_item(slot: int) -> ItemInstance:
	if slot < 0 or slot >= num_slots: return
	
	var uid := slots[slot]
	if uid == "": return null
	return Inventory.get(uid)

func clear_slot(slot: int) -> void:
	if slot < 0 or slot >= num_slots: return

	slots[slot] = ""
	slot_changed.emit(slot, "")

func try_use(slot: int) -> void:
	var inst: ItemInstance = get_item(slot)
	if inst == null:
		failed.emit(slot, "Empty")
		return
	if inst.data.max_stack > 1:
		Inventory.remove(inst.uid, 1)
	else:
		Inventory.remove(inst.uid)
