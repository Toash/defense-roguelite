extends HBoxContainer

## UI to display a status effect.
class_name StatusEffectUI


@export var texture_rect: TextureRect
@export var label: Label
var status_group: StatusEffectGroup


# func _init(status_group: StatusEffectGroup):
# 	set_status_effect_group(status_group)
func setup(status_group: StatusEffectGroup):
	set_status_effect_group(status_group)

func set_status_effect_group(status_group: StatusEffectGroup):
	self.status_group = status_group
	if status_group.amount <= 0:
		queue_free()
	texture_rect.texture = status_group.status_effect.icon
	label.text = "x " + str(status_group.amount)
