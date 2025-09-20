extends Node

signal item_instance_added(instance: ItemInstance)
signal item_instance_removed(instance: ItemInstance)
signal item_instance_changed(instance: ItemInstance)

var _uid_to_instance: Dictionary = {}


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

func all_instances() -> Array:
	return _uid_to_instance.values()