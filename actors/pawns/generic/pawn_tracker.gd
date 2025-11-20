extends Node2D

class_name PawnTracker

signal found_pawn(pawn: Pawn)


@export var factions_to_track: Array[Pawn.FACTION]

## mask should include layers to track.
@export var pawn_vision: Area2D
## ensure this raycast gets obstructed by walls
@export var pawn_raycast: RayCast2D

var retries = 0
const MAX_RETRIES = 50 ## only find player if we can see this many times in a row.

var pawns_within_vision: Dictionary[int, Node2D] = {}

func _ready() -> void:
	pawn_vision.body_entered.connect(_on_body_entered)
	pawn_vision.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# print(pawns_within_vision)
	for pawn in pawns_within_vision.values():
		# pawn_raycast to all humans in the area
		pawn_raycast.target_position = pawn_raycast.to_local(pawn.global_position)
		if pawn_raycast.is_colliding():
			# if pawn_raycast.is_in_group("player"):
			if pawn_raycast.get_collider() is Pawn:
				retries += 1
				if MAX_RETRIES <= retries:
					found_pawn.emit(pawn_raycast.get_collider() as Pawn)
			else:
				retries = 0
				# print("Obstruction")

func _on_body_entered(body: Node2D):
	if body is Pawn:
		if (body as Pawn).faction in factions_to_track:
			pawns_within_vision[body.get_instance_id()] = body
			

func _on_body_exited(body: Node2D):
	if body is Pawn:
		if (body as Pawn).faction in factions_to_track:
			pawns_within_vision[body.get_instance_id()] = body
