extends CanvasLayer


@export var popup_scene: PackedScene
# func

func popup(text: String, screen_pos: Vector2):
	var time = 4.5

	var popup_inst = popup_scene.instantiate()
	popup_inst.text = text
	popup_inst.global_position = screen_pos
	popup_inst.scale = Vector2(1, 1)
	add_child(popup_inst)


	get_tree().create_timer(time).timeout.connect(func():
		popup_inst.queue_free.call_deferred()
	)


func damage_popup(text: String, screen_pos: Vector2):
	var time = 1.5

	var popup_inst = popup_scene.instantiate()
	popup_inst.text = text
	popup_inst.global_position = screen_pos
	popup_inst.scale = Vector2(1, 1)
	popup_inst.modulate.a = 1
	get_tree().root.add_child(popup_inst)


	var offset = Vector2(120, -250)

	create_tween().tween_property(popup_inst, "position", screen_pos + offset, time)

	create_tween().tween_property(popup_inst, "scale", Vector2(2, 2), time)


	get_tree().create_timer(time - .25).timeout.connect(func():
		create_tween().tween_property(popup_inst, "modulate:a", 0, time - .25)
	)

	get_tree().create_timer(time).timeout.connect(func():
		popup_inst.queue_free.call_deferred()
	)
