extends Node2D


## worldgen and pathfinding 
class_name World

signal generated_spawn_nodes(nodes: Array[Node2D])

@export var world_config: WorldConfig

@export_group("TileMapLayers")
@export var tiles_root: Node2D
@export var ground_tiles: TileMapLayer
@export var wall_tiles: TileMapLayer
@export var interactable_tiles: TileMapLayer
@export var resource_tiles: TileMapLayer
@export var defense_tiles: TileMapLayer

@export_group("Game")
# @export var spawn_points: Array[Marker2D]
@export var game_state: GameState
@export_group("Debug")
@export var debug_path: DebugPath
var astar_grid: AStarGrid2D = AStarGrid2D.new()

signal world_setup
var setup = false
var scaling_factor: Vector2

## offset to the center of the tile.
var tile_offset: Vector2 = Vector2(8, 8)

var spawn_nodes: Array[Node2D]


# SETUP
# ============================

func _ready():
	setup = false


	_setup()
	setup = true
	world_setup.emit()


func _setup():
	# print("setup!")
	scaling_factor = tiles_root.scale
	_setup_ground()
	_setup_pathfinding()
	

func _setup_ground():
	var world_width = world_config.world_width
	var world_height = world_config.world_height

	var base_width = world_config.base_width
	var base_height = world_config.base_height


	var altitude = FastNoiseLite.new()
	var resource = FastNoiseLite.new()

	# altitude.frequency = .1
	# altitude.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	altitude.fractal_type = FastNoiseLite.FRACTAL_RIDGED


	altitude.seed = randi()
	resource.seed = randi()
	# altitude.noise_type = FastNoiseLite.TYPE_PERLIN
	ground_tiles.clear()
	
	resource_tiles.clear()
	GroundItems.clear()


	var tree_counter: int = 0
	var tree_interval: int = 30

	var stone_counter: int = 0
	var stone_interval: int = 30

	for x in range(-world_width / 2, world_width / 2):
		for y in range(-world_height / 2, world_height / 2):
			var altitude_value: float = altitude.get_noise_2d(x, y)
			var resource_value: float = resource.get_noise_2d(x, y)

			var alt_enum: WorldEnums.ALTITUDE = _get_altitude(altitude_value)
			var resource_enum: WorldEnums.RESOURCE = _get_resource(resource_value)


			# ensure we have room to build for base.
			# if x >= -base_width / 2 and x <= base_width / 2:
			# 	if y >= -base_height / 2 and y <= base_height / 2:
			# 		ground_tiles.set_cell(Vector2i(x, y), world_config.altitude_to_source_id[WorldEnums.ALTITUDE.GRASS], Vector2i(0, 0))
			# 		continue


			# altitude
			var altitude_tile: TileInfo = world_config.altitude_enum_to_tile[alt_enum]
			var altitude_source_id = altitude_tile.source_id
			var altitude_atlas_coord = altitude_tile.atlas_coord
			var altitude_map_layer: WorldEnums.LAYER = altitude_tile.layer
			match altitude_map_layer:
				WorldEnums.LAYER.GROUND:
					ground_tiles.set_cell(Vector2i(x, y), altitude_source_id, altitude_atlas_coord)
				WorldEnums.LAYER.WALL:
					wall_tiles.set_cell(Vector2i(x, y), altitude_source_id, altitude_atlas_coord)

			
			# set resource tile.
			if resource_enum != WorldEnums.RESOURCE.ABSOLUTELY_NOTHING:
				var resource_source_id: int = world_config.resource_enum_to_tile[resource_enum].source_id
				var resource_alternative_id: int = world_config.resource_enum_to_tile[resource_enum].alternative_id
				match (resource_enum):
					WorldEnums.RESOURCE.TREE:
						if tree_counter <= tree_interval:
							tree_counter += 1
							continue
						else:
							tree_counter = 0
							if alt_enum == WorldEnums.ALTITUDE.GRASS:
								resource_tiles.set_cell(Vector2i(x, y), resource_source_id, Vector2i(0, 0), resource_alternative_id)
					WorldEnums.RESOURCE.STONE:
						if stone_counter <= stone_interval:
							stone_counter += 1
							continue
						else:
							stone_counter = 0
							if alt_enum == WorldEnums.ALTITUDE.GRASS:
								var local_pos = resource_tiles.map_to_local(Vector2i(x, y))
								var global_pos = resource_tiles.to_global(local_pos)
								GroundItems.spawn_by_name("Stone", 1, global_pos)
								

	# spawn stuff on certain tiles

func _setup_pathfinding():
	# pathfinding
	astar_grid.region = ground_tiles.get_used_rect()
	astar_grid.cell_size = ground_tiles.tile_set.tile_size
	astar_grid.offset = Vector2(8, 8)
	astar_grid.offset = tile_offset
	astar_grid.update()
	for cell_pos in wall_tiles.get_used_cells():
		astar_grid.set_point_solid(cell_pos, true)

func get_astar() -> AStarGrid2D:
	return self.astar_grid

# COORD CONVERSION
# ============================
func _world_to_grid(global_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = ground_tiles.to_local(global_pos)
	var grid_pos = ground_tiles.local_to_map(local_pos)
	return grid_pos


# does not include positions  in which there are impassable wall/terrain
func _grid_to_world(cell: Vector2i) -> Vector2:
	return astar_grid.get_point_position(cell)


# SPAWNING
# ============================
func get_spawn_nodes(target_global: Vector2, amount: int) -> Array[Node2D]:
	clear_spawn_points()
	for i in amount:
		_append_spawn_node(target_global)
	generated_spawn_nodes.emit(spawn_nodes)
	return spawn_nodes
	

## TODO, dont pick spawnpoints for a x radius around other spawnpoints.
func _append_spawn_node(target_global: Vector2) -> Node2D:
	var target_cell: Vector2i = _world_to_grid(target_global)

	for i in 100:
		var angle_deg: float = randf_range(0, 360)


		var radius: float = world_config.world_height * ground_tiles.tile_set.tile_size.x * 1.8
		var candidate_global := target_global + Vector2.RIGHT.rotated(deg_to_rad(angle_deg)) * radius
		print("Candidate global: " + str(candidate_global))


		# TODO: Check if there is a path to the nexus !
		# var candidate_cell: Vector2i = _world_to_grid(candidate_global)

		# if not astar_grid.is_in_boundsv(candidate_cell):
		# 	print("World: candidate cell is not in bounds" + str(candidate_cell))
		# 	continue
		# if astar_grid.is_point_solid(candidate_cell):
		# 	print("World: candidate cell is solid")
		# 	continue

		# # check path from spawn_cell to target cell.
		# var path: PackedVector2Array = astar_grid.get_point_path(candidate_cell, target_cell)
		# if path.is_empty():
		# 	print("World: path to target is empty")
		# 	continue

		var node2d: Node2D = Node2D.new()
		# node2d.global_position = _grid_to_world(candidate_cell)
		node2d.global_position = candidate_global

		spawn_nodes.append(node2d)
		return node2d
		
	push_error("World: could generate a spawn point")
	return null


func get_random_spawn_point() -> Vector2:
	## TODO: fallback if no spawn points
	return spawn_nodes[randi()%spawn_nodes.size()].global_position


func clear_spawn_points():
	for spawn_node: Node2D in spawn_nodes:
		spawn_node.queue_free()
	spawn_nodes.clear()
	
			
# RANDOM GEN 
# ============================
func _get_altitude(val: float) -> WorldEnums.ALTITUDE:
	for band in world_config.altitude_bands:
		if val <= band.max:
			return band.type
	# fallback
	return world_config.altitude_bands[-1]["type"]


func _get_resource(val: float) -> WorldEnums.RESOURCE:
	for band in world_config.resource_bands:
		if val >= band.min and val <= band.max:
			return band.type
	return WorldEnums.RESOURCE.ABSOLUTELY_NOTHING


# MISC
# ============================

func get_debug_path() -> DebugPath:
	return self.debug_path


func get_layer(key: WorldEnums.LAYER) -> TileMapLayer:
	match key:
		WorldEnums.LAYER.GROUND:
			return ground_tiles
		WorldEnums.LAYER.WALL:
			return wall_tiles
		WorldEnums.LAYER.INTERACTABLE:
			return interactable_tiles
		WorldEnums.LAYER.DEFENSE:
			return defense_tiles
		_:
			return null
