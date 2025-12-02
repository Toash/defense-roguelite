extends RigidBody2D


class_name Projectile


signal projectile_entered_body(projectile: Node2D, body: Node2D, data: ProjectileData)

var data: ProjectileData

func _ready() -> void:
	self.body_entered.connect(_body_entered)

func _enter_tree() -> void:
	if data.context.user_node is RuntimeDefense:
		var player = get_tree().get_first_node_in_group("player")
		add_collision_exception_with(player)


func _physics_process(delta: float) -> void:
	global_position += Utils.rad_to_unit_vector(global_rotation) * data.speed * delta

func setup(data: ProjectileData):
	self.data = data

func _body_entered(body: Node2D):
	projectile_entered_body.emit(self, body, data)
