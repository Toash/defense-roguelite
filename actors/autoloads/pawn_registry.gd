# PawnRegistry(autoload)
extends Node


@export_group("Pawns")
@export var zombie: PackedScene

var _map: Dictionary[PawnEnums.KEY, PackedScene]


func _ready():
	_map[PawnEnums.KEY.PAWNS_ZOMBIE] = zombie

func get_pawn(key: PawnEnums.KEY) -> Node2D:
	return _map[key].instantiate()

func get_key(string: String) -> PawnEnums.KEY:
	if string == "zombie":
		return PawnEnums.KEY.PAWNS_ZOMBIE
	return PawnEnums.KEY.PAWNS_ZOMBIE
