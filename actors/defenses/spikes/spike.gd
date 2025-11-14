extends Node2D

class_name Spike

@export var damage = 25
@export var area: Area2D
@export var health: Health


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_entered.connect(_on_body_exited)


func _on_body_entered(body: Node2D):
	var health: Health = body.get_node_or_null("Health") as Health
	if health != null:
		health.damage(damage)

func _on_body_exited(body: Node2D):
	pass
