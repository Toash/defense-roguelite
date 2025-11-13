extends State


@export var wander_speed = 50
@export var wander_timer: Timer
@export var wander_radius = 400

@export var player_tracker: PlayerTracker
@export var character: CharacterBody2D
@export var nav: NavigationAgent2D

@export var target: ZombieTarget

var wander_point: Vector2
var rng = RandomNumberGenerator.new()


var active = false


func _ready() -> void:
	wander_point = character.global_position
	wander_timer.timeout.connect(_on_timeout)
	

func state_enter():
	active = true
	player_tracker.found_player.connect(_on_found_player)

func state_physics_update(delta: float):
	if active == false: return

	if !nav.is_target_reached():
		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - character.global_position).normalized()


		character.velocity = normal_dir * wander_speed
		character.move_and_slide()
	

func state_exit():
	active = false
	player_tracker.found_player.disconnect(_on_found_player)


func _on_timeout():
	var new_wander_point = Vector2(character.global_position.x + rng.randf_range(-wander_radius, wander_radius), character.global_position.y + rng.randf_range(-wander_radius, wander_radius))
	nav.target_position = new_wander_point

func _on_found_player(player: Player):
		target.reference = player
		transitioned.emit(self, "chase")