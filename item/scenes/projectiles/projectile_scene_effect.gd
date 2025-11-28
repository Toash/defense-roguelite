extends Node2D
class_name ProjectileSceneEffect

@export var projectile: Projectile

func _ready():
	projectile.projectile_entered_body.connect(_on_projectile_entered_body)

func _on_projectile_entered_body(projectile: Node2D, body: Node2D, data: ProjectileData):
	# shared checks
	if body == data.context.user_node:
		return

	var pawn: Pawn = body as Pawn
	if pawn and pawn.faction not in data.factions_to_hit:
		return

	# per-projectile behavior
	_apply_effect(projectile, body, data)

	# shared cleanup
	projectile.queue_free()

# override this in subclasses
func _apply_effect(projectile: Node2D, body: Node2D, data: ProjectileData) -> void:
	pass
