extends Node2D


## Given an instance, check if that instance  has a build effect effect,
## if so, highlight the tile on the mouse position.
class_name PlayerBuildHighlight


@export var player: Player
@export var mouse_input: MouseInput
@export var instance_provider: ItemInstanceProvider

@export var tile_highlight: Sprite2D

# layer that the scene exists on
var ghost_scene_layer: WorldEnums.LAYER
# the scene to show
var ghost_scene: PackedScene

var current_inst: ItemInstance
var world: World
var show: bool = false

var highlight_radius: float
var centered_highlight_position: Vector2
var defense_manager: DefenseManager

func _ready():
	if not show:
		_hide()
	instance_provider.instance_changed.connect(_on_instance_changed)
	world = get_node("/root/World") as World
	defense_manager = ((get_node("/root/World/GameState") as GameState).defense_manager)

func _process(delta):
	if not show: return
	var global_pos = mouse_input.get_target_pos()
	var local_pos = world.ground_tiles.to_local(global_pos)
	var map_pos: Vector2i = world.ground_tiles.local_to_map(local_pos)

	var final_pos = world.ground_tiles.map_to_local(map_pos)
	centered_highlight_position = final_pos
# print(centered_highlight_position)

	tile_highlight.global_position = final_pos * world.scaling_factor

	queue_redraw()
	pass

func _get_scene_tile(tile_info: TileInfo) -> PackedScene:
	var layer: TileMapLayer = world.get_layer(tile_info.layer)

	var tile_set: TileSet = layer.tile_set
	var scene_source: TileSetScenesCollectionSource = tile_set.get_source(tile_info.source_id)

	if scene_source == null:
		push_error("PlayerBuildHighlight: Source is not a scene tile! perhaps it is a regular tile?")

	var packed_scene: PackedScene = scene_source.get_scene_tile_scene(tile_info.alternative_id)
	return packed_scene


func _show():
	queue_redraw()
	tile_highlight.visible = true
	show = true

func _hide():
	queue_redraw()
	tile_highlight.visible = false
	show = false


func _draw():
	if show:
		var inv = get_global_transform().affine_inverse()
		draw_set_transform_matrix(inv)
		draw_circle(centered_highlight_position * world.scaling_factor, highlight_radius * world.scaling_factor.x, Color.GREEN, false)

func _on_instance_changed(inst: ItemInstance):
	if inst == null:
		_hide()
		return
		
	if inst.data.has_build_effect():
		var effect: BuildEffect = inst.data.get_first_build_effect()
		
		if effect is BuildDefenseEffect:
			var defense_data = DefenseRegistry.get_defense_data(inst.data.display_name)
			var base_radius = defense_data.attack_range
			highlight_radius = base_radius
		_show()
	else:
		_hide()
