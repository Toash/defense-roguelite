extends Node2D

class_name Nexus

@export var area: Area2D


func _ready():
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
	if body is Enemy:
		body.queue_free()
