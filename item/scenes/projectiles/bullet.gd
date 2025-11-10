extends RigidBody2D


class_name Bullet

@export var speed = 1200
@export var damage = 25


func _ready() -> void:
	self.body_entered.connect(_body_entered)
	# self.body_shape_entered.connect(_body_shape_entered)
	# pass

func _physics_process(delta: float) -> void:
	global_position += Utils.rad_to_unit_vector(global_rotation) * speed * delta


func _body_entered(body: Node2D):
	# print("asdfbasioafbd")
	var health := body.get_node_or_null("Health") as Health
	if health:
		health.damage(self.damage)

	queue_free()
