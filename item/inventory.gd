extends Node

signal item_instance_added(uid: String)
signal item_instance_removed(uid: String)
signal item_instance_changed(uid: String)

# contains ItemInstances
var _by_uid: Dictionary = {}

func add(inst: ItemInstance) -> void:
	_by_uid[inst.uid] = inst
	item_instance_added.emit(inst)

func remove(uid: String, qty := -1) -> void:
	var inst = _by_uid.get(uid)
	if inst == null: return
	if qty < 0 or inst.qty <= qty:
		_by_uid.erase(uid)
		item_instance_removed.emit(uid)
	else:
		inst.qty -= qty
		item_instance_changed.emit(uid)

# saving
# convert items into an array format that we can save
func serialize() -> Array:
	var a := []
	for inst: ItemInstance in _by_uid.values():
		a.append({"uid": inst.uid, "resource": inst.data.resource_path, "qty": inst.qty})
	return a

# loading
# take array format, transfer to inventory.
func deserialize(arr: Array) -> void:
	_by_uid.clear()
	for e in arr:
		var def: ItemData = load(e.resource)
		var inst := ItemInstance.new(def, int(e.qty))
		inst.uid = e.uid
		_by_uid[inst.uid] = inst
