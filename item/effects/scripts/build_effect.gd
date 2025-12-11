extends ItemEffect


class_name BuildEffect

@export var tile_info: TileInfo


func apply(context: ItemContext):
	var world: World = context.root_node.get_tree().get_first_node_in_group("world") as World
	var layer: TileMapLayer = world.get_layer(tile_info.layer)


	var local_pos: Vector2 = layer.to_local(context.global_target_position)
	var tile_pos: Vector2i = layer.local_to_map(local_pos)


	# check if the existing position isnt alreaduy occupied.
	var existing_source_id := layer.get_cell_source_id(tile_pos)
	if existing_source_id != -1:
		print("already existing")
		return false

	# place the tile at the position.
	layer.set_cell(tile_pos, tile_info.source_id, tile_info.atlas_coord, tile_info.alternative_id)
