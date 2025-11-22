# PawnSpawner (autolaod)
extends Node


func _process(delta):
	for node in get_tree().get_nodes_in_group("enemy"):
		print(node)

func spawn_pawn(key: PawnEnums.KEY, global_position: Vector2):
	var pawn: Node2D = PawnRegistry.get_pawn(key)
	pawn.global_position = global_position
	get_tree().root.add_child(pawn)

func spawn_pawn_on_player(key: PawnEnums.KEY):
	var pawn: Node2D = PawnRegistry.get_pawn(key)

	pawn.global_position = get_tree().get_first_node_in_group("player").global_position
	get_tree().root.add_child(pawn)

func spawn_pawn_near_player(key: PawnEnums.KEY, offset):
	var pawn: Node2D = PawnRegistry.get_pawn(key)

	pawn.global_position = get_tree().get_first_node_in_group("player").global_position + offset

	get_tree().root.add_child(pawn)

func spawn_horde(key: PawnEnums.KEY, amount):
	var rng = RandomNumberGenerator.new()
	for i in amount:
		spawn_pawn_near_player(key, (Vector2.UP * 800).rotated(deg_to_rad(rng.randf_range(0, 360))))
