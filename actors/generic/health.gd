extends Node2D


## ensure that this is a direct child of the main node and not renamed. 
## ( lots of components are checking if this a direct child.)
class_name Health

signal died
signal health_changed(new_value)


@export var max_health: int = 100
@export var bar_height_offset: float = -50
@onready var health: int = max_health

@onready var bar_offset := Vector2(-20, bar_height_offset)


const bar_width := 40
const bar_height := 6

func _ready():
	health_changed.connect(func(val: int):
		queue_redraw()
		)
	queue_redraw()


func to_dict() -> Dictionary:
	return {
		"health": self.health,
		"max_health": self.max_health
	}

func from_dict(dict: Dictionary) -> void:
	self.health = dict.health
	self.max_health = dict.max_health


func _draw():
	# Make drawing ignore world/node scaling
	var gs := global_scale
	if gs.x != 0.0 and gs.y != 0.0:
		# Apply inverse of total scale so bar stays the same size visually
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0 / gs.x, 1.0 / gs.y))

	# background
	draw_rect(Rect2(bar_offset, Vector2(bar_width, bar_height)), Color(0, 0, 0, 0.4))

	# percentage
	var ratio := float(health) / max_health
	var filled_w := bar_width * ratio

	# filled bar
	draw_rect(Rect2(bar_offset, Vector2(filled_w, bar_height)), Color(0, 1, 0))


func damage(amount: int):
	TextPopupManager.damage_popup(str(amount), global_position)
	if health <= 0: return

	health = clamp(health - amount, 0, max_health)

	health_changed.emit(health)

	if health <= 0:
		died.emit()


func heal(amount: float):
	if health <= 0: return

	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health)

func set_health(health: int) -> void:
	self.health = health

func set_max_health(h: int) -> void:
	self.max_health = h

func get_health() -> int:
	return self.health

func get_max_health() -> int:
	return self.max_health
