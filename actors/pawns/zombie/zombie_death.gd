extends Node

class_name ZombieDeath


@export var state_machine: StateMachine
@export var character_sprite: CharacterSprite
@export var state_machine_debug: StateMachineDebug
@export var tile_pathfind: TilePathfind


func _on_death():
    if state_machine_debug != null:
        state_machine_debug.queue_free()
    state_machine.queue_free()
    tile_pathfind.queue_free()
    character_sprite.die()

    await get_tree().create_timer(5).timeout

    get_parent().queue_free()