extends CharacterBody2D

## Generic "Humanoid"
class_name Pawn

enum FACTION {
	NO_FACTION,
	HUMAN,
	ZOMBIE
}

@export var faction: FACTION

# @export_group("Stats")
var pawn_name: String
# var walk_speed: float = 200


@export_group("References")
@export var health: Health