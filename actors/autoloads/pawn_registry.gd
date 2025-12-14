# EnemyRegistry(autoload)
# contains the scenes for pawns to be spawned
extends Node


var enemies: Dictionary[String, EnemyData]

@export var zombie: PackedScene

func _ready():
	_load_enemy_data("res://actors/pawns/enemies/resources")


func get_data(id: String) -> EnemyData:
	if !enemies.has(id):
		push_error("Enemy does not exist with id " + id)
		return null
	return enemies[id]
	

func _load_enemy_data(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir():
			# if file_name != "." and file_name != "..":
			_load_enemy_data("%s/%s" % [path, file_name])
		elif file_name.ends_with(".tres"):
			var enemy_data: EnemyData = load("%s/%s" % [path, file_name])
			_register(enemy_data)

		file_name = dir.get_next()
	
	dir.list_dir_end()


func _register(enemy_data: EnemyData):
	var id: String = enemy_data.id

	if id.is_empty():
		push_error("enemy data id is empty!")
		return

	if enemies.has(id):
		push_error("id is already present in the registry!")
		return

	enemies[id] = enemy_data
