extends State


@export var wander_speed = 50
@export var wander_timer: Timer
@export var wander_radius = 400

@export var character: CharacterBody2D
@export var vision: Area2D
@export var nav: NavigationAgent2D
@export var sprite: AnimatedSprite2D

@export var target: ZombieTarget
@export var raycast: RayCast2D

var wander_point: Vector2
var rng = RandomNumberGenerator.new()

var humans_within_vision: Dictionary[int, Node2D] = {}

var active = false


func _ready() -> void:
	wander_point = character.global_position

	vision.body_entered.connect(_on_body_entered)
	wander_timer.timeout.connect(_on_timeout)
	

func state_enter():
	active = true

func state_physics_update(delta: float):
	if active == false: return

	for human in humans_within_vision.values():
		# raycast to all humans in the area
		raycast.target_position = character.to_local(human.global_position)
		if raycast.get_collider():
			# print("Obstruction detected.")
			continue

		target.reference = human
		transitioned.emit(self, "chase")

	if !nav.is_target_reached():
		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - character.global_position).normalized()

		if normal_dir.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

		character.velocity = normal_dir * wander_speed
		character.move_and_slide()
	

func state_exit():
	active = false

func _on_body_entered(body: Node2D):
	if active == false: return
	if body.is_in_group("player"):
		humans_within_vision[body.get_instance_id()] = body

func _on_body_exited(body: Node2D):
	if active == false: return
	if body.is_in_group("player"):
		humans_within_vision.erase(body.get_instance_id())


func _on_timeout():
	var new_wander_point = Vector2(character.global_position.x + rng.randf_range(-wander_radius, wander_radius), character.global_position.y + rng.randf_range(-wander_radius, wander_radius))
	nav.target_position = new_wander_point
