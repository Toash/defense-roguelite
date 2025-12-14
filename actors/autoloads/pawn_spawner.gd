# EnemySpawner(autolaod)
extends Node

## TODO make this runtime, not autoload

func spawn_enemy(id: String, global_position: Vector2) -> void:
	var data: EnemyData = EnemyRegistry.get_data(id)
	var scene = data.scene.instantiate() as RuntimeEnemy
	scene.setup(data)
	scene.global_position = global_position
	get_tree().root.add_child(scene)
	Console.log_message("Spawned enemy " + id + ".")

# func spawn_pawn_on_player(key: PawnEnums.NAME):
# 	var pawn: Node2D = EnemyRegistry.get_pawn(key)

# 	pawn.global_position = get_tree().get_first_node_in_group("player").global_position
# 	get_tree().root.add_child(pawn)

# func spawn_pawn_near_player(key: PawnEnums.NAME, offset):
# 	var pawn: Node2D = EnemyRegistry.get_pawn(key)

# 	pawn.global_position = get_tree().get_first_node_in_group("player").global_position + offset

# 	get_tree().root.add_child(pawn)

# func spawn_horde(key: PawnEnums.NAME, amount):
# 	var rng = RandomNumberGenerator.new()
# 	for i in amount:
# 		spawn_pawn_near_player(key, (Vector2.UP * 800).rotated(deg_to_rad(rng.randf_range(0, 360))))
