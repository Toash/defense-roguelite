extends Node

## orchestrator for when npc dies.
class_name NPCDeathController


@export var health: Health
@export var pawn: Pawn
@export var state_machine: StateMachine
@export var tile_pathfind: TilePathfind

func _ready():
	health.died.connect(_on_death)


func _on_death():
	state_machine.queue_free()
	if tile_pathfind != null:
		tile_pathfind.queue_free()

	pawn.set_collision_layer_value(3, false)
	await get_tree().create_timer(5).timeout
	get_parent().queue_free.call_deferred()
