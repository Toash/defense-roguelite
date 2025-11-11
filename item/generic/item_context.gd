## Data needed to perform item effects.
## passed when an item is used.
## items can use the data passed into here to do more stuff.
class_name ItemContext
extends RefCounted


var root_node: Node

## who is using this item
var user_node: Node


var global_spawn_point: Vector2
var spawn_node: Node2D


var target_provider: TargetProvider
var global_target_point: Vector2
var target_node: Node2D

var equip_display: ItemDisplay
var character_sprite: CharacterSprite

var flipped: bool


func _to_string() -> String:
    return "Root node: " + str(root_node) + \
    "\nUser node: " + str(user_node) + \
    "\nGlobal spawn point: " + str(global_spawn_point) + \
    "\nSpawn node: " + str(spawn_node) + \
    "\nGlobal target point: " + str(global_target_point) + \
    "\nEquip display: " + str(equip_display) + \
    "\nFlipped: " + str(flipped)