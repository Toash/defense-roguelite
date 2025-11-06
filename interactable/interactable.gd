extends Area2D


class_name Interactable

signal interacted

@export var sprite: Sprite2D
@export var outline: ShaderMaterial


func interact():
	interacted.emit()


func show_outline():
	outline.set_shader_parameter("outline_thickness", 6)
	sprite.material = outline

func hide_outline():
	sprite.material = null
