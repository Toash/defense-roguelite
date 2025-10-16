extends Node

# autoload that contains the games itemdata.

var _id_to_data: Dictionary[int, ItemData] = {}
var _name_to_data: Dictionary[String, ItemData] = {}

@export var items: Array[ItemData] = []


func _ready() -> void:
	_load_item_data("res://item/items")
	# build the index
	for data in items:
		if !data.display_name:
			push_error("ItemDatabase: Item with missing name.")
			continue
		if _id_to_data.has(data.id) or _name_to_data.has(data.display_name):
			push_error("ItemDatabase: Database already has this item")
			continue

		_id_to_data[data.id] = data
		_name_to_data[data.display_name.to_lower()] = data

func has(id: int) -> bool:
	return _id_to_data.has(id)

func get_all() -> Array[ItemData]:
	return items

func get_from_id(id: int) -> ItemData:
	var data = _id_to_data.get(id, null)
	if data == null:
		print("ItemDatabase: Trying to get item that does not exist from its id.")
	return data

func get_from_display_name(display_name: String) -> ItemData:
	var data = _name_to_data.get(display_name.to_lower(), null)
	if data == null:
		print("ItemDatabase: Trying to get item that does not exist from its name.")
	return data


func _load_item_data(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# if file_name != "." and file_name != "..":
			_load_item_data("%s/%s" % [path, file_name])
		elif file_name.ends_with(".tres"):
			var data: ItemData = load("%s/%s" % [path, file_name])
			if data:
				items.append(data)
		file_name = dir.get_next()
	
	dir.list_dir_end()
