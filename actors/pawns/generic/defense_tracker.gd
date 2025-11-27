extends Node2D

class_name DefenseTracker

signal found_defense(defense: Defense)


@export var visibility_level: Defense.PRIORITY

@export var vision_distance :float = 300

## mask should include layers to track.
var defense_vision: Area2D
## ensure this raycast gets obstructed by walls
var defense_raycast: RayCast2D

var retries = 0
const MAX_RETRIES = 50 ## only find player if we can see this many times in a row.
const COOLDOWN = 2 ## cooldown after having discovered a defense.
var t: float = INF

var defenses_within_vision: Dictionary[int, Defense] = {}

func _ready() -> void:
	defense_vision = PhysicsUtils.get_circle_area(vision_distance)
	defense_vision.set_collision_mask_value(6,true)
	add_child(defense_vision)
	
	defense_raycast= RayCast2D.new()
	defense_raycast.set_collision_mask_value(2,true)
	defense_raycast.set_collision_mask_value(6,true)
	add_child(defense_raycast)

	defense_vision.area_entered.connect(_on_area_entered)
	defense_vision.area_exited.connect(_on_area_exited)

func _process(delta):
	t += delta

func _physics_process(delta):
	# print(defenses_within_vision)
	for defense in defenses_within_vision.values():
		defense_raycast.target_position = defense_raycast.to_local(defense.global_position)
		defense_raycast.collide_with_areas = true
		if defense_raycast.is_colliding():
			# if defense_raycast.is_in_group("player"):
			if defense_raycast.get_collider() is Defense:
				retries += 1
				if MAX_RETRIES <= retries:
					if t > COOLDOWN:
						found_defense.emit(defense_raycast.get_collider() as Defense)
						t = 0
			else:
				retries = 0
				print("Obstruction")

func _on_area_entered(area: Area2D):
	if area is Defense:
		defenses_within_vision[area.get_instance_id()] = area as Defense

func _on_area_exited(area: Area2D):
	if area is Defense:
		defenses_within_vision.erase(area.get_instance_id())
