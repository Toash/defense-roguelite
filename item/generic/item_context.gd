## Data needed to perform item effects.
class_name ItemContext
extends RefCounted


var root_node: Node

## who is using this item
var user_node: Node


var global_spawn_point: Vector2
var spawn_node: Node2D


var global_target_point: Vector2

var equip_display: ItemDisplay
var flipped: bool


func _to_string() -> String:
    return "Root node: " + str(root_node) + \
    "\nUser node: " + str(user_node) + \
    "\nGlobal spawn point: " + str(global_spawn_point) + \
    "\nSpawn node: " + str(spawn_node) + \
    "\nGlobal target point: " + str(global_target_point) + \
    "\nEquip display: " + str(equip_display) + \
    "\nFlipped: " + str(flipped)