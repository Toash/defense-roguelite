## ContentManager.gd (Autoload) handles context menus.
extends CanvasLayer

@export var context_menu: Control
@export var context_menu_vbox: VBoxContainer
@export var context_offset: Vector2 = Vector2(16, 16)

var context_opened = false


func _ready():
	visible = false


## the "packed scenes" are responsible for creating the functionality
func show_context(controls: Array[Control]):
	context_opened = !context_opened
	visible = context_opened

	context_menu.global_position = get_viewport().get_mouse_position() + context_offset

	_remove_children()
	
	for control: Control in controls:
		context_menu_vbox.add_child(control)


func hide_context():
	context_opened = false
	visible = false
	_remove_children()


func _remove_children():
	for child in context_menu_vbox.get_children():
		context_menu_vbox.remove_child(child)
