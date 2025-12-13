class_name HealthUI
extends PanelContainer


@export var progress_bar: TextureProgressBar


var health: Health


func _ready():
	_on_health_changed(0)
func setup(health: Health):
	self.health = health
	health.health_changed.connect(_on_health_changed)

func _on_health_changed(_new_value: int):
	var ratio = health.get_ratio()
	print(ratio)

	var progress_bar_diff = progress_bar.max_value - progress_bar.min_value
	var min_value = progress_bar.min_value

	progress_bar.value = min_value + (progress_bar_diff * ratio)
