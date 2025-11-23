extends Control


class_name OffscreenIndicators

@export var indicator_scene: PackedScene
@export var side_indicator_texture: Texture2D
@export var indicator_texture: Texture2D
@export var camera: Camera2D
@export var margin: float = 64.0 # distance from edge

var indicators: Dictionary[Node2D, TextureRect] = {}
var targets: Array[Node2D]

func _process(delta: float) -> void:
	if camera == null:
		camera = get_viewport().get_camera_2d()
		if camera == null:
			return

	var rect := get_viewport_rect()
	var center := rect.size * 0.5
	var zoom := camera.zoom

	# clean up dead / removed targets
	for t in indicators.keys():
		if not is_instance_valid(t) or not targets.has(t):
			indicators[t].queue_free()
			indicators.erase(t)

	# add indicators for new targets
	for t in targets:
		if not indicators.has(t):
			var ind := indicator_scene.instantiate()
			add_child(ind)
			# ind.visible = false
			indicators[t] = ind

	# update all indicators
	var center_world := camera.get_screen_center_position()

	for t in indicators.keys():
		var ind: TextureRect = indicators[t]

		# world -> screen (manual)
		var delta_world: Vector2 = t.global_position - center_world
		var screen_offset := Vector2(
			delta_world.x / zoom.x,
			delta_world.y / zoom.y
		)
		var screen_pos := center + screen_offset

		# on-screen? hide arrow
		if rect.has_point(screen_pos):
			ind.texture = indicator_texture
		else:
			ind.texture = side_indicator_texture

		# clamp to edges with margin
		var clamped := Vector2(
			clamp(screen_pos.x, margin, rect.size.x - margin),
			clamp(screen_pos.y, margin, rect.size.y - margin)
		)
		ind.position = clamped

		# point arrow toward target
		var angle := (screen_pos - center).angle()
		ind.rotation = angle
