extends ItemEffect

class_name HealEffect

@export var heal_amount: int

func apply(user, ctx):
    var health: Health = user.get_node_or_null("Health")
    if not Health: push_error("Could not find health on the player")

    health.heal(heal_amount)