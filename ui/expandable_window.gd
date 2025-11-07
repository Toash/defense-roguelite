extends PanelContainer


# Wrapper for anything that needs an expandable window.
class_name ExpandableWindow


@export var window_title: String = "Window"

## the scene that the expandable window contains.
@export var content_scene: PackedScene

@export var start_minimized = false
@export var width = 300


@export var content_container: VBoxContainer
@export var hbox: HBoxContainer
@export var minimize_button: Button
@export var title_label: Label


var content: Node

var is_minimized := false
var _dragging := false
var _drag_offset := Vector2.ZERO


func _ready() -> void:
	title_label.text = window_title
	minimize_button.pressed.connect(_on_minimize_pressed)
	_instantiate_content()

	size.x = width
	# size.x = content_container.get_child(0).size.x
	# $TitleBar.gui_input.connect(_on_titlebar_gui_input)

	if start_minimized:
		minimize()

func get_content() -> Node:
	return self.content

func expand():
	is_minimized = false
	content_container.visible = true

func minimize():
	is_minimized = true
	content_container.visible = false

func toggle():
	_on_minimize_pressed()

	
func _instantiate_content():
	for child in content_container.get_children():
		# child.queue_free()
		child.call_deferred("queue_free")
	if content_scene:
		content = content_scene.instantiate()
		content_container.add_child(content)

func _on_minimize_pressed():
	is_minimized = !is_minimized
	content_container.visible = not is_minimized

	# ?
	# if is_minimized:
	# 	custom_minimum_size.y = $TitleBar.size.y
	# else:
	# 	custom_minimum_size.y = 0


func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
		else:
			_dragging = false
	elif e is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset
