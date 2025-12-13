extends Node2D

class_name ProjectileBullet


@export var projectile: ProjectileScene

func _ready():
	projectile.projectile_entered_body.connect(on_projectile_entered_body)

func on_projectile_entered_body(projectile: Node2D, body: Node2D, hit_context: HitContext):
	# if body == data.item_context.user_node: return
	var health := body.get_node_or_null("Health") as Health
	if health:
		health.apply_hit(hit_context)

	projectile.queue_free()
