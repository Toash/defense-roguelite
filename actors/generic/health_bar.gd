extends Node2D

class_name HealthBar

@export var health: Health
@export var bar_size := Vector2(8, 4)
@export var bar_color := Color(0, 1, 0)
@export var bg_color := Color(1, 0, 0)
@export var offset := Vector2(0, -10)

@export var text_offset := Vector2(-25, -40)

var max_hp: int
var hp: int

var show: bool = true

var font: Font = preload("res://ui/fonts/Poco.ttf")
var font_size = 1

func _ready():
	if health == null:
		push_error("HealthBar: no health supplied!")


	max_hp = health.max_health
	hp = health.health

	health.health_changed.connect(set_hp)

	# font = ThemeDB.fallback_font
	font_size = ThemeDB.fallback_font_size


func _draw() -> void:
	if not show:
		return

	self.z_index = 999
	if hp <= 0:
		return

	var ratio := clamp(float(hp) / float(max_hp), 0.0, 1.0)

	# bar is drawn in LOCAL space, so offset is applied here
	var top_left := offset - bar_size * 0.5

	# background
	draw_rect(Rect2(top_left, bar_size), bg_color, true)

	# filled portion
	var fill_size := Vector2(bar_size.x * ratio, bar_size.y)
	draw_rect(Rect2(top_left, fill_size), bar_color, true)

	# If using this method in a script that redraws constantly, move the
	# `font` declaration to a member variable assigned in `_ready()`
	# so the Control is only created once.
	var health_string = str(health.get_health()) + " / " + str(health.get_max_health())
	draw_string(font, position + text_offset, health_string, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)

func set_hp(new_hp: int):
	hp = clamp(new_hp, 0, max_hp)
	queue_redraw()

	# show = true
	# queue_redraw()
	# await get_tree().create_timer(2).timeout
	# show = false
	# queue_redraw()
