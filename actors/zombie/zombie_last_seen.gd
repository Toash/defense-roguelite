extends State


@export var speed = 200
@export var character: CharacterBody2D

@export var vision: Area2D
@export var raycast: RayCast2D

@export var nav: NavigationAgent2D
@export var sprite: AnimatedSprite2D


@export var target: ZombieTarget

var active = false


func _ready() -> void:
	vision.body_entered.connect(_on_body_entered)

func state_enter():
	active = true
	print("Going to last seen position.")

func state_physics_update(delta: float):
	if active == false: return

	nav.target_position = target.last_position

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - character.global_position).normalized()

	if normal_dir.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	character.velocity = normal_dir * speed
	character.move_and_slide()
	if nav.is_navigation_finished():
		transitioned.emit(self, "wander")
	

func state_exit():
	active = false

func _on_body_entered(body: Node2D):
	if active == false: return

	if body.is_in_group("player"):
		raycast.target_position = character.to_local(body.global_position)
		if raycast.get_collider():
			print("Obstruction detected.")
			return

		target.reference = body
		transitioned.emit(self, "chase")
