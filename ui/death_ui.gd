extends Control

class_name DeathUI

@export var button: Button


func _ready():
	button.pressed.connect(_on_pressed)


func _on_pressed():
	get_tree().reload_current_scene()


func show():
	visible = true
