extends Node2D

class_name ContextInput

signal request_context(viewport_pos: Vector2, global_pos: Vector2)

var viewport_mouse_pos: Vector2
var global_pos: Vector2

func _process(delta):
    viewport_mouse_pos = get_viewport().get_mouse_position()
    global_pos = get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("open_context"):
        request_context.emit(viewport_mouse_pos, global_pos)