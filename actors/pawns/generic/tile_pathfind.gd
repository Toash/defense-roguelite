extends Node2D

class_name TilePathfind

@export var body: CharacterBody2D

var speed: float = 200

@onready var world: World = get_tree().get_first_node_in_group("world") as World
@onready var grid: AStarGrid2D = world.get_astar()
var path: PackedVector2Array
var path_index: int

var enabled = false

func _ready():
	if world == null:
		push_error("Could not find world!")
	if grid == null:
		push_error("Could not find grid!")

	
func set_target(target_global_pos: Vector2):
	# HACK awaiting until a node is not null? 
	while world == null:
		await get_tree().process_frame

	# print("setting target")
	path.clear()
	path_index = 0


	var ground_layer: TileMapLayer = world.get_layer(World.TILE_KEY.GROUND)

	var from_cell: Vector2i = ground_layer.local_to_map(ground_layer.to_local(body.global_position))
	var to_cell: Vector2i = ground_layer.local_to_map(ground_layer.to_local(target_global_pos))

	path = grid.get_point_path(from_cell, to_cell, true)

	if not path:
		return

	var raw_path: PackedVector2Array = grid.get_point_path(from_cell, to_cell)

	path = PackedVector2Array()
	for p in raw_path:
		var global_p: Vector2 = ground_layer.to_global(p)
		path.append(global_p)

	world.get_debug_path().set_path(path)

func set_speed(speed: float):
	self.speed = speed

func enable():
	enabled = true
func disable():
	if world.debug_path:
		world.debug_path.set_path([])
	enabled = false

func _physics_process(delta: float) -> void:
	if not enabled: return
	
	if path.is_empty():
		body.velocity = Vector2.ZERO
		body.move_and_slide()
		return

	var target: Vector2 = world.to_global(path[path_index])
	var to_target: Vector2 = target - body.global_position
	var dist := to_target.length()

	if dist < 4:
		print("blegghh!")
		path_index += 1
		# end of path
		if path_index >= path.size():
			path.clear()
			body.velocity = Vector2.ZERO
			body.move_and_slide()
			return
		return
	
	var dir: Vector2 = to_target / dist
	body.velocity = dir * speed
	body.move_and_slide()


func is_navigating():
	return not path.is_empty()
