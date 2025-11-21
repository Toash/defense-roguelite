extends RigidBody2D


class_name Projectile

var factions_to_hit: Array[Pawn.FACTION]
var speed = 1200
var damage = 25

var context: ItemContext


func _ready() -> void:
	self.body_entered.connect(_body_entered)

func _physics_process(delta: float) -> void:
	global_position += Utils.rad_to_unit_vector(global_rotation) * speed * delta

func setup(ctx: ItemContext):
	self.context = ctx

func _body_entered(body: Node2D):
	if body == context.user_node: return

	var pawn: Pawn = body as Pawn
	if pawn and pawn.faction not in factions_to_hit:
		return

	var health := body.get_node_or_null("Health") as Health
	if health:
		health.damage(self.damage)

	queue_free()
