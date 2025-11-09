extends Node2D


## emits positions for arms 

signal left_hand_pos_emitted(pos: Vector2)
signal right_hand_pos_emitted(pos: Vector2)

var target: Vector2


func _set_target(pos: Vector2):
	target = pos

func _process(delta):
	# determine positions for left and right hand
	var dir: Vector2 = (target - global_position).normalized()

	var left_hand_pos = global_position + dir * 25
	var right_hand_pos = global_position + dir.rotated(deg_to_rad(35)) * 25

	left_hand_pos_emitted.emit(left_hand_pos)
	right_hand_pos_emitted.emit(right_hand_pos)