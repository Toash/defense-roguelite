extends ItemEffect


class_name BuildEffect

#informatino for specifying what tile it is we are building with.
# what layer are we building on ?

@export var layer_key: World.TILE_KEY
@export var source_id: int
@export var atlas_coords: Vector2i


# atlas coords?

func apply(context: ItemContext):
	var world: World = context.root_node.get_tree().get_first_node_in_group("world") as World
	var layer: TileMapLayer = world.get_layer(layer_key)

	var local_pos: Vector2 = layer.to_local(context.global_target_position)
	var tile_pos: Vector2i = layer.local_to_map(local_pos)


	# place the tile at the position.
	layer.set_cell(tile_pos, source_id, atlas_coords)
