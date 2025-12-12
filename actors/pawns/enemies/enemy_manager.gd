extends Node2D


class_name EnemyManager


func get_all_enemies() -> Array[Node]:
	return get_tree().get_nodes_in_group("enemy")
