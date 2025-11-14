extends Node2D

## keeps track of players nearby, to see if they are visible.
class_name PlayerTracker

signal found_player(player: Player)


@export var vision: Area2D
## ensure this raycast gets obstructed by walls
@export var player_raycast: RayCast2D

var retries = 0
const MAX_RETRIES = 50 ## only find player if we can see this many times in a row.

var humans_within_vision: Dictionary[int, Node2D] = {}

func _ready() -> void:
	vision.body_entered.connect(_on_body_entered)
	vision.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# print(humans_within_vision)
	for human in humans_within_vision.values():
		# player_raycast to all humans in the area
		player_raycast.target_position = player_raycast.to_local(human.global_position)
		if player_raycast.is_colliding():
			# if player_raycast.is_in_group("player"):
			if player_raycast.get_collider() is Player:
				retries += 1
				if MAX_RETRIES <= retries:
					found_player.emit(player_raycast.get_collider() as Player)
			else:
				retries = 0
				print("Obstruction")

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		humans_within_vision[body.get_instance_id()] = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		humans_within_vision.erase(body.get_instance_id())
