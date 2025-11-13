extends Node2D

## keeps track of players nearby, to see if they are visible.
class_name PlayerTracker

signal found_player(player: Player)


@export var vision: Area2D
@export var raycast: RayCast2D


var humans_within_vision: Dictionary[int, Node2D] = {}

func _ready() -> void:
	vision.body_entered.connect(_on_body_entered)
	vision.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# print(humans_within_vision)
	for human in humans_within_vision.values():
		# raycast to all humans in the area
		raycast.target_position = raycast.to_local(human.global_position)
		if raycast.is_colliding():
			# if raycast.is_in_group("player"):
			if raycast.get_collider() is Player:
				found_player.emit(raycast.get_collider() as Player)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		humans_within_vision[body.get_instance_id()] = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		humans_within_vision.erase(body.get_instance_id())