extends Pawn


## contains centralized data for an enemy 

# Enemies will have specific balancing for:
	# Spawn cost 
	# Health 
	# Movespeed
	# Attack Speed  
	# Attack Damage 
class_name Enemy

@export var enemy_data: EnemyData

@export var state_machine: StateMachine
@export var tile_pathfind: TilePathfind

func _ready():
	add_to_group("enemy")
	health.died.connect(_on_death)


func setup(data: EnemyData):
	enemy_data = data
	self.health.set_max_health(int(data.health))
	self.health.set_health(data.health)

func _on_death():
	remove_from_group("enemy")

	state_machine.queue_free()
	tile_pathfind.queue_free()

	set_collision_layer_value(3, false)
	await get_tree().create_timer(5).timeout
	queue_free.call_deferred()