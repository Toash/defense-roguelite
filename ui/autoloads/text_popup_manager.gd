extends CanvasLayer


@export var popup_scene: PackedScene
# func

func popup(text: String, screen_pos: Vector2):
	var time = 4.5

	var popup_inst = popup_scene.instantiate()
	popup_inst.text = text
	popup_inst.global_position = screen_pos
	popup_inst.scale = Vector2(2, 2)
	add_child(popup_inst)


	get_tree().create_timer(time).timeout.connect(func():
		popup_inst.queue_free.call_deferred()
	)
