extends Camera2D

@export var min_zoom = 1
@export var max_zoom = 3
@export var zoom_speed = 1.5
@export var touchpad_zoom_speed = 0.05

var zooming_in: bool = false
var zooming_out: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventPanGesture:
		zoom = clamp(zoom - Vector2(event.delta.y, event.delta.y) * touchpad_zoom_speed, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zooming_in = true
	if Input.is_action_just_pressed("zoom_out"):
		zooming_out = true

	if Input.is_action_just_released("zoom_in"):
		zooming_in = false
	if Input.is_action_just_released("zoom_out"):
		zooming_out = false

	if zooming_in:
		zoom = clamp(zoom + Vector2(zoom_speed, zoom_speed) * delta, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	if zooming_out:
		zoom = clamp(zoom - Vector2(zoom_speed, zoom_speed) * delta, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
