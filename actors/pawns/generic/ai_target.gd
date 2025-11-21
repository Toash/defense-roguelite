extends TargetProvider

class_name AITarget

var reference: Node2D

var last_position: Vector2 = Vector2.ZERO


func _process(delta):
	if reference:
		target_pos_emitted.emit(reference.global_position)

func get_target_pos() -> Vector2:
	if reference:
		last_position = reference.position
		return reference.position

	return last_position
