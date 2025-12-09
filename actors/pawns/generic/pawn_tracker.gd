extends Node2D

## Keeps track of nearby pawns based on faction, line of sight, and nearest.
class_name PawnTracker

signal pawn_line_of_sight(pawn: Pawn)
signal nearest_pawn_changed(previous_pawn: Pawn, new_pawn: Pawn)


@export var factions_to_track: Array[Pawn.FACTION]
@export var vision_distance: float = 300

## mask should include layers to track.
var pawn_vision: Area2D
## ensure this raycast gets obstructed by walls
var pawn_and_obstruction_raycast: RayCast2D

var retries = 0
const MAX_RETRIES = 10 ## only find player if we can see this many times in a row.

# var pawns_within_vision: Dictionary[int, Node2D] = {}
var nearby_pawns: Dictionary[Pawn, float] = {}
var nearest_pawn: Pawn


func get_nearest_pawn() -> Pawn:
	var _nearest_pawn = null
	var _nearest_distance: float = INF

	for pawn: Pawn in nearby_pawns:
		var distance: float = nearby_pawns[pawn]
		if distance < _nearest_distance:
			_nearest_pawn = pawn
			_nearest_distance = distance
	return _nearest_pawn

func _ready() -> void:
	pawn_vision = PhysicsUtils.get_circle_area(vision_distance)
	pawn_vision.set_collision_mask_value(3, true)
	add_child(pawn_vision)
	
	pawn_and_obstruction_raycast = RayCast2D.new()
	pawn_and_obstruction_raycast.set_collision_mask_value(2, true)
	pawn_and_obstruction_raycast.set_collision_mask_value(3, true)
	add_child(pawn_and_obstruction_raycast)

	pawn_vision.body_entered.connect(_on_body_entered)
	pawn_vision.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# for pawn in pawns_within_vision.values():
	for pawn in nearby_pawns.keys():
		pawn_and_obstruction_raycast.target_position = pawn_and_obstruction_raycast.to_local(pawn.global_position)
		if pawn_and_obstruction_raycast.is_colliding():
			if pawn_and_obstruction_raycast.get_collider() is Pawn:
				retries += 1
				if MAX_RETRIES <= retries:
					pawn_line_of_sight.emit(pawn_and_obstruction_raycast.get_collider() as Pawn)
			else:
				retries = 0

	for pawn: Pawn in nearby_pawns:
		var distance = (global_position - pawn.global_position).length()
		nearby_pawns[pawn] = distance

	if get_nearest_pawn() != nearest_pawn:
		nearest_pawn_changed.emit(nearest_pawn, get_nearest_pawn())
		nearest_pawn = get_nearest_pawn()

	
func _on_body_entered(body: Node2D):
	if body is Pawn:
		if (body as Pawn).faction in factions_to_track:
			# pawns_within_vision[body.get_instance_id()] = body
			var distance = (global_position - body.global_position).length()
			nearby_pawns[body as Pawn] = distance
			
			
func _on_body_exited(body: Node2D):
	if body is Pawn:
		if (body as Pawn).faction in factions_to_track:
			# pawns_within_vision[body.get_instance_id()] = body
			nearby_pawns.erase(body as Pawn)
