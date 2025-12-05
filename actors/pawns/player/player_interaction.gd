extends Node2D

## handles interaction for current interactable of a player.
class_name PlayerInteraction


@export var interact_detector: InteractDetector
@export var context_input: ContextInput

@export var player: Node2D

# @export var interaction_collision_shape: CollisionShape2D
@export var outline_material: ShaderMaterial

var nearest_interactable: Interactable
var interactable_layer: TileMapLayer
# var interact_distance: float

func _ready():
	# if interaction_collision_shape.shape is not CircleShape2D:
	# 	push_error("PlayerInteraction: CollisionShape should be a circle.")
	# interact_distance = interaction_collision_shape.shape.radius + 200
	interactable_layer = (get_tree().get_first_node_in_group("world") as World).interactable_tiles
	interact_detector.nearest_interactable_changed.connect(_on_nearest_interactable_changed)
	context_input.request_context.connect(_on_request_context)

## Gets the container of the nearest interactable, if it has a container
func get_nearest_container_if_it_exists() -> ItemContainer:
	if nearest_interactable != null:
		for child in nearest_interactable.get_parent().get_children():
			if child is ItemContainer:
				return child as ItemContainer
	return null


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if nearest_interactable:
			_interact(nearest_interactable, player)
		

func _interactable_in_range(interactable, player) -> bool:
	var interact_pos: Vector2 = interactable.global_position
	var player_pos: Vector2 = player.global_position

	var distance = (interact_pos - player_pos).length()

	# if distance < interact_distance:
	if interact_detector.has_interactable(interactable):
		return true
	else:
		return false


func _interact(interactable: Interactable, player: Node2D):
	if _interactable_in_range(interactable, player):
		interactable.interact(player)


func _on_nearest_interactable_changed(new_interactable: Interactable):
	if nearest_interactable != null:
		nearest_interactable.hide_outline()

	if new_interactable != null:
		new_interactable.show_outline(outline_material)

	nearest_interactable = new_interactable
	print("PlayerInteraction: Current interactable: " + str(nearest_interactable))
	ContextManager.hide_context()


func _on_request_context(global_pos: Vector2):
	# TODO: Shouldnt this just be on the ui? instead of physics
	var param: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	param.collide_with_areas = true
	param.position = global_pos

	var datas = get_world_2d().direct_space_state.intersect_point(param)
	for data in datas:
		# areas can be intersected as well.
		if data.collider:
			if data.collider is Interactable:
				var interactable = data.collider as Interactable
				if _interactable_in_range(interactable, player):
					# ContextManager.show_context((interactable.context_nodes).duplicate(true))
					ContextManager.show_context(interactable.context_nodes)
					return

	ContextManager.hide_context()
