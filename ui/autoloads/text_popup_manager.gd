extends CanvasLayer


@export var popup_scene: PackedScene
# func

func popup(text: String, screen_pos: Vector2):
	var time = 4.5

	var popup_inst = popup_scene.instantiate()
	popup_inst.text = text
	popup_inst.global_position = screen_pos
	popup_inst.scale = Vector2(5, 5)
	popup_inst.modulate.a = 0
	add_child(popup_inst)

	var fade_in_time = 1

	create_tween().tween_property(popup_inst, "modulate:a", 1, fade_in_time) # scale to 2× over 0.5s
	create_tween().tween_property(popup_inst, "scale", Vector2(2.5, 2.5), fade_in_time) # scale to 2× over 0.5s

	var fade_out_time = 1


	get_tree().create_timer(time - fade_out_time).timeout.connect(func():
		create_tween().tween_property(popup_inst, "modulate:a", 0.0, fade_out_time) # fade out over 0.5s
		)


	get_tree().create_timer(time).timeout.connect(func():
		popup_inst.queue_free.call_deferred()
	)
