# PawnRegistry(autoload)
# contains the scenes for pawns to be spawned
extends Node


@export_group("Pawns")
@export var zombie: PackedScene

var _map: Dictionary[PawnEnums.NAME, PackedScene]


func _ready():
	_map[PawnEnums.NAME.BASIC_ZOMBIE] = zombie

func get_pawn(key: PawnEnums.NAME) -> Node2D:
	return _map[key].instantiate()

func get_key(string: String) -> PawnEnums.NAME:
	if string == "zombie":
		return PawnEnums.NAME.BASIC_ZOMBIE
	return PawnEnums.NAME.BASIC_ZOMBIE
