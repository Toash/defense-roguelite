extends CanvasLayer


@export var root: Control
var is_open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


func open():
	is_open = true
	visible = true
	get_tree().paused = true
	root.grab_focus()

func close():
	is_open = false
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_open:
			close()
		else:
			open()


func _on_resume_pressed() -> void:
	close()


func _on_save_pressed() -> void:
	SaveManager.save_game()


func _on_load_pressed() -> void:
	SaveManager.load_game()
	close()


func _on_quit_pressed() -> void:
	print("quit")
