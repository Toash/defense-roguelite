extends Node2D


# wave number
	# spawn stuff every random intrrval (Faster spawning in later waves)
	# spawner has increased budget on later waves 

# each enemy has a cost
class_name WaveSpawner


@export var freeze: bool = false
@export var enemy_root: Node2D
@export var enemy_data: EnemyData

var world: World
var t: float = 0

var spawn_points: Array[Marker2D]

func _ready():
	world = get_tree().get_first_node_in_group("world") as World
	await world.world_setup


	spawn_points = world.spawn_points


func _process(delta):
	if freeze: return
	t += delta

	if t > 2:
		spawn_enemy(enemy_data, _get_random_spawn_point())
		t = 0

	
func spawn_enemy(data: EnemyData, global_pos: Vector2):
	var enemy: Enemy = data.scene.instantiate() as Enemy
	if enemy == null:
		push_error("WaveSpawner: Enemy is not of type enemy. ")

	enemy.setup(data)
	enemy.global_position = global_pos
	enemy_root.add_child.call_deferred(enemy)

	print("WaveSpawner: spawned " + enemy.pawn_name)
	

func _get_random_spawn_point() -> Vector2:
	if spawn_points.size() <= 0:
		push_error("Spawner does not have spawn points!")
		return Vector2.ZERO

	var spawn_point: Vector2 = spawn_points[randi() % spawn_points.size()].global_position
	print(spawn_point)
	return spawn_point
