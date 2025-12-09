extends State


@export var swivel_root: Node2D

var defense: RuntimeDefense
var rng
var t: float = 0
var interval = 1

var target_rotation_degrees: float
var rotate_amount: float = 100

const THRESHOLD = 1
var real_interval = interval

func _ready():
	defense = get_node("../..") as RuntimeDefense
	if defense == null:
		push_error("Could not find runtime defense!")


func state_enter():
	rng = RandomNumberGenerator.new()
	target_rotation_degrees = swivel_root.rotation_degrees
	defense.pawn_tracker.nearest_pawn_changed.connect(_on_nearest_pawn_changed)

func state_update(delta: float):
	if swivel_root.rotation_degrees < target_rotation_degrees - THRESHOLD:
		swivel_root.rotation_degrees += rotate_amount * delta
	elif swivel_root.rotation_degrees > target_rotation_degrees + THRESHOLD:
		swivel_root.rotation_degrees -= rotate_amount * delta

	t += delta
	if t > real_interval:
		_swivel_to_random_point()
		t = 0


func state_physics_update(delta: float):
	pass

func state_exit():
	defense.pawn_tracker.nearest_pawn_changed.disconnect(_on_nearest_pawn_changed)
	pass

func _swivel_to_random_point():
	var curr_deg = swivel_root.rotation_degrees
	target_rotation_degrees = rng.randf_range(curr_deg - 90, curr_deg + 90)

	# real_interval = interval + rng.randf_range(-2, 2)

func _on_nearest_pawn_changed(a: Pawn, pawn: Pawn):
	transitioned.emit(self, "attack")
