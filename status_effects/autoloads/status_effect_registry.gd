## StatusEffectRegistry (Autoload)
## assigns ids to status effects holds all registered status effects from the filesystem.
extends Node


var _id_to_status_effects: Dictionary[int, StatusEffect]

func _ready() -> void:
	_load_data("res://status_effects/resources")

func get_all() -> Array[StatusEffect]:
	return _id_to_status_effects.values()

func get_by_id(id: int) -> StatusEffect:
	return _id_to_status_effects[id]


func _load_data(path: String) -> void:
	var id_count: int = 0
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# if file_name != "." and file_name != "..":
			_load_data("%s/%s" % [path, file_name])
		elif file_name.ends_with(".tres"):
			var status_effect: StatusEffect = load("%s/%s" % [path, file_name])
			_add(id_count, status_effect)
			id_count += 1

			
		file_name = dir.get_next()
	
	dir.list_dir_end()


func _add(id: int, status_effect: StatusEffect):
	status_effect.id = id
	_id_to_status_effects[id] = status_effect