extends State


@export var wander_speed = 80

@export var wander_radius: float = 250

@export var wander_interval_default: float = 10
@export var wander_interval_random: float = 4

@export var player_tracker: PlayerTracker
@export var character: CharacterBody2D
@export var tile_pathfind: TilePathfind

@export var target: ZombieTarget

var wander_interval: float


var wander_point: Vector2
var rng = RandomNumberGenerator.new()
var t: float = 0


var active = false


func state_enter():
	active = true

	wander_point = character.global_position
	wander_interval = wander_interval_default + rng.randf_range(-wander_interval_random, wander_interval_random)

	player_tracker.found_player.connect(_on_found_player)
	tile_pathfind.enable()
	tile_pathfind.set_speed(wander_speed)


func state_physics_update(delta: float):
	if active == false: return
	t += delta
	if t > wander_interval:
		_on_timeout()
		t = 0
		wander_interval = wander_interval_default + rng.randf_range(-wander_interval_random, wander_interval_random)
	

func state_exit():
	active = false
	player_tracker.found_player.disconnect(_on_found_player)
	tile_pathfind.disable()


func _on_timeout():
	var rand_x = rng.randf_range(-wander_radius, wander_radius)
	var rand_y = rng.randf_range(-wander_radius, wander_radius)

	var new_wander_point = Vector2(character.global_position.x + rand_x, character.global_position.y + rand_y)
	print(new_wander_point)
	tile_pathfind.set_target(new_wander_point)

func _on_found_player(player: Player):
	target.reference = player
	transitioned.emit(self, "chase")
