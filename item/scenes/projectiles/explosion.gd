extends Area2D

class_name Explosion

@export var damage: int = 50
@export var lifetime: float = 0.25


func explode() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):
	for body in get_overlapping_bodies():
		print("body")
		var health: Health = body.get_node_or_null("Health") as Health
		print(health)
		if health != null:
			health.damage(damage)
