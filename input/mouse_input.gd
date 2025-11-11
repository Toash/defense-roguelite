extends TargetProvider

class_name MouseInput


signal mouse_position(pos: Vector2)
signal mouse_local_direction(dir: Vector2)

func _process(delta):
	var mouse_pos: Vector2 = get_global_mouse_position()

	var dir = (to_local(mouse_pos) - position).normalized()

	mouse_position.emit(mouse_pos)
	mouse_local_direction.emit(dir)
	target_pos_emitted.emit(mouse_pos)

func get_target_pos() -> Vector2:
	var mouse_pos: Vector2 = get_global_mouse_position()
	print(mouse_pos)
	return mouse_pos
