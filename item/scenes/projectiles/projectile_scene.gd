extends RigidBody2D


## refers to a projectile.
class_name ProjectileScene


signal projectile_entered_body(projectile: Node2D, body: Node2D, hit_context: HitContext)

var item_context: ItemContext
var data: ProjectileData
var initial_rotation: float

func _ready() -> void:
	self.body_entered.connect(_body_entered)

func _enter_tree() -> void:
	if data.item_context.user_node is RuntimeDefense:
		var player = get_tree().get_first_node_in_group("player")
		add_collision_exception_with(player)

	linear_velocity = Utils.rad_to_unit_vector(global_rotation) * data.speed
	initial_rotation = global_rotation


func setup(item_context: ItemContext, data: ProjectileData):
	self.item_context = item_context
	self.data = data

func _body_entered(body: Node2D):
	var hit_context: HitContext = HitContext.new({
		HitContext.Key.HITTER: data.item_context.user_node,
		HitContext.Key.DIRECTION: Utils.rad_to_unit_vector(initial_rotation),
		HitContext.Key.STATUS_EFFECTS: [],
		HitContext.Key.KNOCKBACK: 400,
		HitContext.Key.BASE_DAMAGE: data.damage
	})

	projectile_entered_body.emit(self, body, hit_context)
