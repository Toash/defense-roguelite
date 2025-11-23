extends TextureRect


@export var pulsate_amount: float = 1.6
@export var pulsate_time: float = 0.8


func _ready():
	pulsate()

func pulsate():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(pulsate_amount, pulsate_amount), pulsate_time)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), pulsate_time)
