extends Node2D


## contains information about the world
class_name World

@export var ground_tiles: TileMapLayer
@export var wall_tiles: TileMapLayer
@export var interactable_tiles: TileMapLayer


enum TILE_KEY {
	GROUND,
	WALL,
	INTERACTABLE
}


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