extends Area2D


class_name Interactable

signal interacted(action_id: int, player: Node2D)

## used for outlining the interactable.
@export var sprite: Sprite2D

# @export var outline: ShaderMaterial

# @export_group("Action names")
# @export var main_action_name = "use"


# var actions: Dictionary[String, Callable]
@export var actions: Array[String]

## Creates an interactable object with the specified radius.
static func create_interactable(radius: float) -> Interactable:
	var interactable: Interactable = new()
	interactable.set_collision_layer_value(5, true)
	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	collision_shape.shape = circle
	interactable.add_child(collision_shape)
	return interactable

# have list of actions
# include the action name ( string ) on the interacted event
# thigns that listen for the interacted event will also get the actino name.


func interact(player: Node2D):
	interacted.emit(player)


func show_outline(outline: ShaderMaterial):
	if sprite == null:
		return
	outline.set_shader_parameter("outline_thickness", 1)
	sprite.material = outline

func hide_outline():
	sprite.material = null
