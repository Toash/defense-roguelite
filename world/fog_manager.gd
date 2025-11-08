extends Node


## spawns fog throughout the world.
class_name FogManager


@export var disabled = false
@export var fog_scene: PackedScene
@export var world_root: Node
@export var spacing: float = 200
@export var ground_layer: TileMapLayer


func _ready():
	if disabled: return
	var tile_map_origin: Vector2 = ground_layer.get_used_rect().position * ground_layer.tile_set.tile_size.x
	var tile_map_rect: Vector2 = ground_layer.get_used_rect().size * ground_layer.tile_set.tile_size.x
	# _spawn_fog(tile_map_rect.position)
	# spawn fogs according to spacing across tilemap
	for x in range(tile_map_origin.x, tile_map_rect.x, spacing):
		for y in range(tile_map_origin.y, tile_map_rect.y, spacing):
			_spawn_fog(Vector2(x, y))


func _spawn_fog(global_pos: Vector2):
	var fog: Fog = fog_scene.instantiate()
	fog.global_position = global_pos
	world_root.add_child.call_deferred(fog)
