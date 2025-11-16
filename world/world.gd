extends Node2D


## worldgen and pathfinding 
class_name World

@export var ground_tiles: TileMapLayer
@export var wall_tiles: TileMapLayer
@export var interactable_tiles: TileMapLayer
@export var resource_tiles: TileMapLayer
@export var debug_path: DebugPath


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

enum ALTITUDE {
	WATER,
	DIRT,
	GRASS
}

enum RESOURCE {
	ABSOLUTELY_NOTHING,
	TREE,
	STONE
}


func _setup():
	print("setup!")
	_setup_ground()
	_setup_pathfinding()
	

func _setup_ground():
	var world_width = 128
	var world_height = 128

	var base_width = 24
	var base_height = 24


	var altitude = FastNoiseLite.new()
	var resource = FastNoiseLite.new()

	altitude.seed = randi()
	resource.seed = randi()
	# altitude.noise_type = FastNoiseLite.TYPE_PERLIN
	ground_tiles.clear()
	
	resource_tiles.clear()
	GroundItems.clear()


	# these link back to their respective tilesets.
	var altitude_to_source_id: Dictionary[int, int]
	altitude_to_source_id[ALTITUDE.WATER] = 2
	altitude_to_source_id[ALTITUDE.DIRT] = 1
	altitude_to_source_id[ALTITUDE.GRASS] = 0

	var resource_to_source_id: Dictionary[int, int]
	resource_to_source_id[RESOURCE.TREE] = 0

	var resource_to_alternative_id: Dictionary[int, int]
	resource_to_alternative_id[RESOURCE.TREE] = 1


	var tree_counter: int = 0
	var tree_interval: int = 30

	var stone_counter: int = 0
	var stone_interval: int = 30

	for x in range(-world_width / 2, world_width / 2):
		for y in range(-world_height / 2, world_height / 2):
			var altitude_value: float = altitude.get_noise_2d(x, y)
			var resource_value: float = resource.get_noise_2d(x, y)

			var alt_enum: ALTITUDE = _get_altitude(altitude_value)
			var resource_enum: RESOURCE = _get_resource(resource_value)


			# ensure we have room to build for base.
			if x >= -base_width / 2 and x <= base_width / 2:
				if y >= -base_height / 2 and y <= base_height / 2:
					ground_tiles.set_cell(Vector2i(x, y), altitude_to_source_id[ALTITUDE.GRASS], Vector2i(0, 0))
					continue


			# set ground tile
			var altitude_source_id: int = altitude_to_source_id[alt_enum]
			ground_tiles.set_cell(Vector2i(x, y), altitude_source_id, Vector2i(0, 0))

			# set resource tile.
			if resource_enum != RESOURCE.ABSOLUTELY_NOTHING:
				match (resource_enum):
					RESOURCE.TREE:
						if tree_counter <= tree_interval:
							tree_counter += 1
							continue
						else:
							tree_counter = 0
							if alt_enum == ALTITUDE.GRASS:
								var resource_source_id: int = resource_to_source_id[resource_enum]
								var resource_alternative_id: int = resource_to_alternative_id[resource_enum]
								resource_tiles.set_cell(Vector2i(x, y), resource_source_id, Vector2i(0, 0), resource_alternative_id)
					RESOURCE.STONE:
						if stone_counter <= stone_interval:
							stone_counter += 1
							continue
						else:
							stone_counter = 0
							if alt_enum == ALTITUDE.GRASS:
								var local_pos = resource_tiles.map_to_local(Vector2i(x, y))
								var global_pos = resource_tiles.to_global(local_pos)
								GroundItems.spawn_by_name("Stone", 1, global_pos)
								

	# spawn stuff on certain tiles


func _get_altitude(altitude_value: float) -> ALTITUDE:
	var alt_enum: ALTITUDE
	if altitude_value < -0.2:
		alt_enum = ALTITUDE.WATER
	elif altitude_value >= -0.2 and altitude_value < 0:
		alt_enum = ALTITUDE.DIRT
	else:
		alt_enum = ALTITUDE.GRASS

	return alt_enum


func _get_resource(val: float) -> RESOURCE:
	var resource_enum: RESOURCE
	if val >= -0.1 and val <= 0:
		return RESOURCE.TREE
	elif val >= -0 and val <= .1:
		return RESOURCE.STONE

	return RESOURCE.ABSOLUTELY_NOTHING


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
