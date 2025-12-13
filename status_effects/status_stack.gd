## represents a group of status effects.
class_name StatusStack


var status_effect: StatusEffect
var amount: int


func _init(status_effect: StatusEffect, amount: int) -> void:
    self.status_effect = status_effect
    self.amount = amount
