extends CanvasLayer

@export var context_menu: Control
@export var context_menu_vbox: VBoxContainer
@export var context_offset: Vector2 = Vector2(16, 16)

var context_opened = false


func _ready():
	visible = false


func toggle_context(actions: Array[String]):
	context_opened = !context_opened
	visible = context_opened
	if context_opened:
		for button in context_menu_vbox.get_children():
			button.queue_free()

		context_menu.global_position = get_viewport().get_mouse_position() + context_offset

		for action in actions:
			var button = Button.new()
			button.text = action
			context_menu_vbox.add_child(button)


func clear_context():
	context_opened = false
	visible = false
	for button in context_menu_vbox.get_children():
		button.queue_free()
