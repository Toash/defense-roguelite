extends State


@export var speed = 150

@export var character: CharacterBody2D
@export var nav: NavigationAgent2D
@export var player_tracker: PlayerTracker

@export var target: ZombieTarget


var active = false
var nexus_pos: Vector2


func _ready() -> void:
	nexus_pos = (get_tree().get_first_node_in_group("nexus") as Nexus).global_position
	
	
func state_enter():
	active = true
	player_tracker.found_player.connect(_on_player_found)
	

func state_physics_update(delta: float):
	if active == false: return

	nav.target_position = nexus_pos

	if !nav.is_target_reached():
		var next_point: Vector2 = nav.get_next_path_position()
		var normal_dir = (next_point - character.global_position).normalized()

		character.velocity = normal_dir * speed
		character.move_and_slide()
	

func state_exit():
	active = false
	player_tracker.found_player.disconnect(_on_player_found)


func _on_player_found(player: Player):
	target.reference = player
	transitioned.emit(self, "chase")
