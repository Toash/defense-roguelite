extends Node2D

class_name HealthBar

@export var health: Health
@export var bar_size := Vector2(8, 4)
@export var bar_color := Color(0, 1, 0)
@export var bg_color := Color(1, 0, 0)
@export var offset := Vector2(0, -10)

var max_hp: int
var hp: int

func _ready():
	if health == null:
		push_error("HealthBar: no health supplied!")


	max_hp = health.max_health
	hp = health.health

	health.health_changed.connect(set_hp)


func _draw() -> void:
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

func set_hp(new_hp: int):
	hp = clamp(new_hp, 0, max_hp)
	queue_redraw()
