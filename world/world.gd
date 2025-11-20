extends Node2D


## worldgen and pathfinding 
class_name World

@export var world_config: WorldConfig

@export var ground_tiles: TileMapLayer
@export var wall_tiles: TileMapLayer
@export var interactable_tiles: TileMapLayer
@export var resource_tiles: TileMapLayer
@export var debug_path: DebugPath

@export var spawn_points: Array[Marker2D]

var astar_grid: AStarGrid2D = AStarGrid2D.new()

signal world_setup
var setup = false


enum TILE_KEY {
	GROUND,
	WALL,
	INTERACTABLE
}


func _ready():
	setup = false


	_setup()
	setup = true
	world_setup.emit()


func _setup():
	# print("setup!")
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

func _setup_pathfinding():
	# pathfinding
	astar_grid.region = ground_tiles.get_used_rect()
	astar_grid.cell_size = ground_tiles.tile_set.tile_size
	astar_grid.offset = Vector2(8, 8)
	astar_grid.update()
	for cell_pos in wall_tiles.get_used_cells():
		astar_grid.set_point_solid(cell_pos, true)

func get_astar() -> AStarGrid2D:
	return self.astar_grid

func get_debug_path() -> DebugPath:
	return self.debug_path

func get_layer(key: TILE_KEY) -> TileMapLayer:
	match key:
		TILE_KEY.GROUND:
			return ground_tiles
		TILE_KEY.WALL:
			return wall_tiles
		TILE_KEY.INTERACTABLE:
			return interactable_tiles
		_:
			return null
