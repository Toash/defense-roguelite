extends CharacterBody2D

## Generic "Humanoid"
class_name Pawn

enum FACTION {
	NO_FACTION,
	HUMAN,
	ZOMBIE
}

@onready var world: World = get_tree().get_first_node_in_group("world") as World
@export var faction: FACTION


# @export_group("Stats")
var pawn_name: String
# var walk_speed: float = 200


@export_group("References")
@export var health: Health