extends Node2D

class_name ProjectileBullet


@export var projectile: Projectile

func _ready():
	projectile.projectile_entered_body.connect(on_projectile_entered_body)

func on_projectile_entered_body(projectile: Node2D, body: Node2D, data: ProjectileData):
	if body == data.context.user_node: return

	var pawn: Pawn = body as Pawn
	if pawn and pawn.faction not in data.factions_to_hit:
		return

	var health := body.get_node_or_null("Health") as Health
	if health:
		health.damage(data.damage)

	projectile.queue_free()
