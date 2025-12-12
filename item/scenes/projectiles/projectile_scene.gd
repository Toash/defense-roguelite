extends RigidBody2D


## refers to a projectile.
class_name ProjectileScene


signal projectile_entered_body(projectile: Node2D, body: Node2D, data: ProjectileData, hit_context: HitContext)

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


func setup(data: ProjectileData):
	self.data = data

func _body_entered(body: Node2D):
	var hit_context: HitContext = HitContext.new()
	hit_context.who_hit = data.item_context.user_node
	hit_context.direction = Utils.rad_to_unit_vector(initial_rotation)

	projectile_entered_body.emit(self, body, data, hit_context)
