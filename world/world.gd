extends Node2D


## contains information about the world
class_name World

@export var ground_tiles: TileMapLayer
@export var wall_tiles: TileMapLayer
@export var interactable_tiles: TileMapLayer
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
	astar_grid.region = ground_tiles.get_used_rect()
	astar_grid.cell_size = ground_tiles.tile_set.tile_size
	astar_grid.offset = Vector2(8, 8)
	astar_grid.update()

	for cell_pos in wall_tiles.get_used_cells():
		astar_grid.set_point_solid(cell_pos, true)


	world_setup.emit()
	setup = true
	
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
