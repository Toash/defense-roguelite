## root_node - Scene tree root, Ex. used as the parent node for projectiles
## user_node - Who is using the item, Ex. used for collision exceptions
## global_spawn_point - Self explanatory
## spawn_node - Ex. used for melee instances to spawn the instance there 
class_name ItemContext
extends RefCounted


## world root node 
## ex. could use for projectiles
var root_node: Node

## who is using this item
var user_node: Node2D


var global_spawn_point: Vector2
var direction: Vector2

## when spawning things, they will be children of this node
## ex. could use for melee instances
var spawn_node: Node2D


var target_provider: TargetProvider
var global_target_position: Vector2
var target_node: Node2D

var equip_display: ItemDisplay
var character_sprite: CharacterSprite

## flip sprite when looking left
var flip_when_looking_left: bool


func _to_string() -> String:
    return "Root node: " + str(root_node) + \
    "\nUser node: " + str(user_node) + \
    "\nGlobal spawn point: " + str(global_spawn_point) + \
    "\nSpawn node: " + str(spawn_node) + \
    "\nGlobal target point: " + str(global_target_position) + \
    "\nEquip display: " + str(equip_display) + \
    "\nFlipped: " + str(flip_when_looking_left)