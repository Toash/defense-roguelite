extends Node2D

class_name PawnTracker

signal got_pawn(pawn: Pawn) # this is redundant, its just the nearest pawn
signal nearest_pawn_changed(previous_pawn: Pawn, new_pawn: Pawn)


@export var factions_to_track: Array[Faction.Type]
@export var vision_distance: float = 300

## mask should include layers to track.
var pawn_vision: Area2D


# var pawns_within_vision: Dictionary[int, Node2D] = {}
var nearby_pawns: Dictionary[Pawn, float] = {}
var nearest_pawn: Pawn
var t: float = 0


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

	pawn_vision.body_entered.connect(_on_body_entered)
	pawn_vision.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	for pawn: Pawn in nearby_pawns:
		var distance = (global_position - pawn.global_position).length()
		nearby_pawns[pawn] = distance
	if get_nearest_pawn() != nearest_pawn:
		nearest_pawn_changed.emit(nearest_pawn, get_nearest_pawn())
		got_pawn.emit(get_nearest_pawn())
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
