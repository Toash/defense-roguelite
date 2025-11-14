extends State


@export var speed = 200
@export var character: CharacterBody2D
@export var player_tracker: PlayerTracker

@export var nav: NavigationAgent2D

@export var target: AITarget

var active = false


func state_enter():
	active = true
	player_tracker.found_player.connect(_on_player_found)
	print("Going to last seen position.")

func state_physics_update(delta: float):
	if active == false: return

	nav.target_position = target.last_position

	var next_point: Vector2 = nav.get_next_path_position()
	var normal_dir = (next_point - character.global_position).normalized()


	character.velocity = normal_dir * speed
	character.move_and_slide()

	if nav.is_navigation_finished():
		transitioned.emit(self, "wander")


func state_exit():
	active = false
	
	player_tracker.found_player.disconnect(_on_player_found)

func _on_player_found(player: Player):
	target.reference = player
	transitioned.emit(self, "chase")