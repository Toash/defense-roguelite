extends CanvasLayer

@export var tooltip: Tooltip
@export var tooltip_offset: Vector2 = Vector2(16, 16)


func _ready():
	visible = false


func show_tooltip(text: String):
	tooltip.set_text(text)
	visible = true

func hide_tooltip():
	visible = false

func _process(delta: float) -> void:
	if visible:
		tooltip.global_position = get_viewport().get_mouse_position() + tooltip_offset
