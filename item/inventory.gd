extends Node

# single source of truth inventory of the player.
# the corresponding ui of this is just a copy of this datya.


signal item_instance_added(instance: ItemInstance)
signal item_instance_removed(instance: ItemInstance)
signal item_instance_changed(instance: ItemInstance)

signal item_instance_moved(uid: String, to_index: int)

var _uid_to_instance: Dictionary[String, ItemInstance] = {}

# used to persist item positions in an inventory.
var _uid_to_slot: Dictionary[String, int] = {}
var _slot_to_inst: Dictionary[int, String] = {}

func add(inst: ItemInstance) -> void:
	_uid_to_instance[inst.uid] = inst
	item_instance_added.emit(inst)

func remove(uid: String, qty := -1) -> void:
	var inst = _uid_to_instance.get(uid)
	if inst == null: return
	if qty < 0 or inst.qty <= qty:
		_uid_to_instance.erase(uid)
		item_instance_removed.emit(inst)
	else:
		inst.qty -= qty
		item_instance_changed.emit(inst)

func move_item(uid: String, index: int) -> void:
	# print("Setting " + str(uid) + " to index " + str(index))
	# print(_uid_to_slot)
	_uid_to_slot[uid] = index
	item_instance_moved.emit(uid, index)

func clear_slot(uid: String) -> void:
	_uid_to_slot.erase(uid)

func get_slot_index_from_uid(uid: String) -> int:
	# print("Getting idx for uid " + str(uid))
	return _uid_to_slot.get(uid, -1)

func all_uids() -> Array[String]:
	return _uid_to_slot.keys()

func all_instances() -> Array[ItemInstance]:
	return _uid_to_instance.values()


# ---- Persistence ------

# saving
# convert items into an array format that we can save
func serialize() -> Array:
	var a := []
	for inst: ItemInstance in _uid_to_instance.values():
		a.append({"uid": inst.uid, "resource": inst.data.resource_path, "qty": inst.qty})
	return a

# loading
# take array format, transfer to inventory.
func deserialize(arr: Array) -> void:
	_uid_to_instance.clear()
	for e in arr:
		var def: ItemData = load(e.resource)
		var inst := ItemInstance.new(def, int(e.qty))
		inst.uid = e.uid
		_uid_to_instance[inst.uid] = inst