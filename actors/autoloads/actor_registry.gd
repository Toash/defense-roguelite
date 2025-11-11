# ActorRegistry (autoload)
extends Node


@export_group("Pawns")
@export var zombie: PackedScene

var _map: Dictionary[KEY, PackedScene]

enum KEY {
	PAWNS_ZOMBIE
}


func _ready():
	_map[KEY.PAWNS_ZOMBIE] = zombie


func get_actor(key: KEY) -> Node2D:
	return _map[key].instantiate()


func get_key(string: String) -> KEY:
	if string == "zombie":
		return KEY.PAWNS_ZOMBIE
	return KEY.PAWNS_ZOMBIE
