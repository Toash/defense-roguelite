## DefenseRegistry (Autoload)
extends Node

var defense_data_pool: Array[DefenseData]
var _name_to_defense_data: Dictionary[String, DefenseData]


func _ready():
	_load_defense_data("res://actors/defenses")


func has_defense_data(defense_name: String) -> bool:
	var data: DefenseData = _name_to_defense_data.get(defense_name)
	if data == null:
		return false
	return true


## gets the defense based off of its corresponding item data display name.
func get_defense_data(defense_name: String) -> DefenseData:
	var data: DefenseData = _name_to_defense_data.get(defense_name)
	if data == null:
		push_error("DefenseRegistry: defense data does not exist for the name " + defense_name)
		return null
	return data


func _load_defense_data(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# if file_name != "." and file_name != "..":
			_load_defense_data("%s/%s" % [path, file_name])
		elif file_name.ends_with(".tres"):
			var defense_data: DefenseData = load("%s/%s" % [path, file_name])
			if defense_data:
				defense_data_pool.append(defense_data)


				var defense_name = defense_data.get_defense_name()
				print(defense_name)
				var duplicate_named_defense = _name_to_defense_data.get(defense_name)
				if duplicate_named_defense != null:
					push_error("DefenseRegistry: defense with name \"" + defense_name + "\" and filepath \"" + file_name + "\" already exists!")
				
				_name_to_defense_data[defense_name] = defense_data


		file_name = dir.get_next()
	
	dir.list_dir_end()
