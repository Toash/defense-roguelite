extends Camera2D

@export var min_zoom = 0.5
@export var max_zoom = 3.0
@export var zoom_speed = 1.5
@export var touchpad_zoom_speed = 0.05
@export var wheel_zoom_step = 0.2

var zooming_in: bool = false
var zooming_out: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		zoom = clamp(
			zoom - Vector2(event.delta.y, event.delta.y) * touchpad_zoom_speed,
			Vector2(min_zoom, min_zoom),
			Vector2(max_zoom, max_zoom)
		)

	elif event is InputEventMouseButton and event.is_pressed():
		if event.button_index == 5:
			# scroll up -> zoom in
			zoom = clamp(
				zoom - Vector2(wheel_zoom_step, wheel_zoom_step),
				Vector2(min_zoom, min_zoom),
				Vector2(max_zoom, max_zoom)
			)
		elif event.button_index == 4:
			# scroll down -> zoom out
			zoom = clamp(
				zoom + Vector2(wheel_zoom_step, wheel_zoom_step),
				Vector2(min_zoom, min_zoom),
				Vector2(max_zoom, max_zoom)
			)

func _process(delta: float) -> void:
	if Console.is_open():
		return

	if Input.is_action_just_pressed("zoom_in"):
		zooming_in = true
	if Input.is_action_just_pressed("zoom_out"):
		zooming_out = true

	if Input.is_action_just_released("zoom_in"):
		zooming_in = false
	if Input.is_action_just_released("zoom_out"):
		zooming_out = false

	if zooming_in:
		zoom = clamp(
			zoom + Vector2(zoom_speed, zoom_speed) * delta,
			Vector2(min_zoom, min_zoom),
			Vector2(max_zoom, max_zoom)
		)
	if zooming_out:
		zoom = clamp(
			zoom - Vector2(zoom_speed, zoom_speed) * delta,
			Vector2(min_zoom, min_zoom),
			Vector2(max_zoom, max_zoom)
		)
