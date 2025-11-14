extends Node

class_name RemoveOnDeath


@export var node_to_remove: Node2D
@export var health: Health


func _ready():
	health.died.connect(_on_death)

func _on_death():
	node_to_remove.queue_free()