## represents a group of status effects.
class_name StatusEffectGroup


var status_effect: StatusEffect
var amount: int


func _init(status_effect: StatusEffect, amount: int) -> void:
	if status_effect == null:
		push_error("Status effect is null!")

	self.status_effect = status_effect
	self.amount = amount


func equals(other: StatusEffectGroup):
	return self.status_effect == other.status_effect
