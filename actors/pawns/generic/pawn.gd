extends CharacterBody2D

class_name Pawn

enum FACTION {
	NO_FACTION,
	HUMAN,
	ZOMBIE
}

@export var faction: FACTION

@export_group("Stats")
@export var walk_speed: float = 200
@export var max_health: float = 20


@export_group("References")
@export var health: Health