extends TargetProvider

class_name ZombieTarget

var reference: Node2D

var last_position: Vector2


func _process(delta):
	if reference:
		target_pos_emitted.emit(reference.global_position)

func get_target_pos() -> Vector2:
	if reference:
		return reference.position

	push_error("Getting target pos when there is no target reference")
	return Vector2.ZERO
