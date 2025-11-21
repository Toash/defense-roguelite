extends Node2D


## Given an instance, check if that instance  has a build effect effect,
## if so, highlight the tile on the mouse position.
class_name PlayerBuildHighlight


@export var player: Player
@export var mouse_input: MouseInput
@export var instance_provider: ItemInstanceProvider


@export var ghost: Sprite2D

var current_inst: ItemInstance
# var world: World
var show: bool = false

func _ready():
	if not show:
		_hide()
	instance_provider.instance_changed.connect(_on_instance_changed)

func _process(delta):
	if not show: return
	# ghost.global_position = mouse_input.get_target_pos()
	var global_pos = mouse_input.get_target_pos()
	var local_pos = player.world.ground_tiles.to_local(global_pos)
	var map_pos: Vector2i = player.world.ground_tiles.local_to_map(local_pos)

	var final_pos = player.world.ground_tiles.map_to_local(map_pos)

	# ghost.scale = player.world.scaling_factor
	ghost.global_position = final_pos * player.world.scaling_factor

	pass

func _show():
	ghost.visible = true
	show = true
func _hide():
	ghost.visible = false
	show = false
func _on_instance_changed(inst: ItemInstance):
	if inst.data.has_build_effect():
		_show()
	else:
		_hide()
