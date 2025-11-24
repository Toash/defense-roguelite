extends Node2D

class_name Nexus

@export var area: Area2D
@export var health: Health

func _ready():
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if body is Enemy:
		health.damage(1)
		body.queue_free()
