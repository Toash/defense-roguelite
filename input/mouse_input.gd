extends Node2D

class_name MouseInput

signal mouse_position(pos: Vector2)

func _process(delta):
	var mouse_pos: Vector2 = get_global_mouse_position()
	mouse_position.emit(mouse_pos)
