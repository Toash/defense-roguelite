extends Panel

class_name Tooltip

@export var label: Label

func set_text(t: String) -> void:
	label.text = t
	size = label.get_combined_minimum_size() + Vector2(8, 8)