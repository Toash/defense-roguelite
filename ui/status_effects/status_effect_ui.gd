extends HBoxContainer

## UI to display a status effect.
class_name StatusEffectUI


var texture_rect := $TextureRect
var label := $Label


var status_stack: StatusStack


func _init(status_stack: StatusStack):
	texture_rect.texture = status_stack.status_effect.icon
	label.text = "x " + str(status_stack.amount)
