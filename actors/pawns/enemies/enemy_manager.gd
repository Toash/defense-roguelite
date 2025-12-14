extends Node2D


class_name RuntimeEnemyManager


func get_all_enemies() -> Array[Node]:
	return get_tree().get_nodes_in_group("enemy")
