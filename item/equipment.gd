extends Node

# represents items that the player has equipped.
class_name Equipment

signal equipped(slot: StringName, uid: String)
signal unequipped(slot: StringName, uid: String)
signal equip_failed(slot: StringName, uid: String, reason: String)

@export var slots: Array[StringName] = [&"MainHand"]
var _slot_to_uid: Dictionary = {} # slot -> uid

func _ready():
	for s in slots: _slot_to_uid[s] = ""

func can_equip(slot: StringName, uid: String) -> Dictionary:
	if not Inventory.has(uid): return {"ok": false, "reason": "NotOwned"}
	return {"ok": true}

func equip(slot: StringName, uid: String) -> void:
	var can_equip = can_equip(slot, uid)
	if not can_equip:
		equip_failed.emit(slot, uid, can_equip.reason)
		return
	var cur: String = _slot_to_uid.get(slot, "")
	if cur != "":
		unequip(slot)
	_slot_to_uid[slot] = uid
	equipped.emit(slot, uid)


func unequip(slot: StringName) -> void:
	var uid: String = _slot_to_uid.get(slot, "")
	if uid == "":
		return
	_slot_to_uid[slot] = ""
	unequipped.emit(slot, uid)

func get_equipped(slot: StringName) -> String:
	return _slot_to_uid.get(slot, "")
