extends CanvasLayer


@export var popup_scene: PackedScene
# func


@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

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


# func damage_popup(text: String, screen_pos: Vector2):
# 	var time = 1

# 	var popup_inst = popup_scene.instantiate()
# 	popup_inst.text = text
# 	popup_inst.global_position = screen_pos
# 	popup_inst.scale = Vector2(.5, .5)
# 	popup_inst.modulate.a = 1
# 	get_tree().root.add_child(popup_inst)


# 	var offset = Vector2(100, -200)

# 	create_tween().tween_property(popup_inst, "position", screen_pos + offset, time)

# 	create_tween().tween_property(popup_inst, "scale", Vector2(1.5, 1.5), time)


# 	get_tree().create_timer(time - .25).timeout.connect(func():
# 		create_tween().tween_property(popup_inst, "modulate:a", 0, time - .25)
# 	)

# 	get_tree().create_timer(time).timeout.connect(func():
# 		popup_inst.queue_free.call_deferred()
# 	)

func damage_popup(text: String, screen_pos: Vector2):
	var popup_inst = popup_scene.instantiate()
	popup_inst.text = text
	popup_inst.global_position = screen_pos
	popup_inst.scale = Vector2(0.6, 0.6)
	popup_inst.modulate.a = 0.0
	get_tree().root.add_child(popup_inst)


	var x = rng.randf_range(-50, 50)
	var y = rng.randf_range(-90, -110)
	var rise_offset := Vector2(x, y)
	# var float_offset := Vector2(0, -20)
	var float_offset := rise_offset + Vector2(0, -20)

	var tween := get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# --- POP IN (short, snappy) ---
	# Move up a bit, overshoot scale, and fade in in parallel
	tween.parallel().tween_property(
		popup_inst, "position",
		screen_pos + rise_offset,
		0.15
	)
	tween.parallel().tween_property(
		popup_inst, "scale",
		Vector2(1.2, 1.2),
		0.15
	)
	tween.parallel().tween_property(
		popup_inst, "modulate:a",
		1.0,
		0.08
	)

	# --- SETTLE (shrink back to normal) ---
	tween.tween_property(
		popup_inst, "scale",
		Vector2.ONE,
		0.25
	)

	# Hang for a bit
	tween.tween_interval(0.25)

	# --- FLOAT + FADE OUT ---
	tween.parallel().tween_property(
		popup_inst, "position",
		popup_inst.position + float_offset,
		0.25
	)
	tween.parallel().tween_property(
		popup_inst, "modulate:a",
		0.0,
		0.25
	)

	tween.finished.connect(func():
		popup_inst.queue_free()
	)
