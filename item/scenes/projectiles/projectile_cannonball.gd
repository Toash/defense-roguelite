extends Node2D

class_name ProjectileCannonball


@export var projectile: Projectile
@export var explosion_scene: PackedScene

func _ready():
	projectile.projectile_entered_body.connect(on_projectile_entered_body)

func on_projectile_entered_body(projectile: Node2D, body: Node2D, data: ProjectileData):
	if body == data.context.user_node: return

	var pawn: Pawn = body as Pawn
	if pawn and pawn.faction not in data.factions_to_hit:
		return

	var explosion_inst: Explosion = explosion_scene.instantiate()
	explosion_inst.global_position = global_position
	
	get_tree().root.add_child.call_deferred(explosion_inst)
	explosion_inst.explode.call_deferred()


	projectile.queue_free()
