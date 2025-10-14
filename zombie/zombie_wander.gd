extends State


@export var wander_speed = 50
@export var wander_timer: Timer
@export var wander_radius = 100

@export var character: CharacterBody2D
@export var vision: Area2D
@export var nav: NavigationAgent2D
@export var sprite: AnimatedSprite2D

@export var zombie_target: Node

var wander_point: Vector2
var rng = RandomNumberGenerator.new()

var active = false


func _ready() -> void:
	wander_point = character.global_position

	vision.body_entered.connect(_on_body_entered)
	wander_timer.timeout.connect(_on_timeout)
	

func state_enter():
	active = true


func state_physics_update(delta: float):
	if active == false: return

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
		print(body)
		zombie_target.target = body
		transitioned.emit(self, "chase")


func _on_timeout():
	var new_wander_point = Vector2(character.global_position.x + rng.randf_range(-wander_radius, wander_radius), character.global_position.y + rng.randf_range(-wander_radius, wander_radius))
	nav.target_position = new_wander_point
