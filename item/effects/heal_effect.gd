extends ItemEffect

class_name HealEffect

@export var heal_amount: int

func apply(context: ItemContext):
    var health: Health = context.user_node.get_node_or_null("Health")
    if not Health: push_error("Could not find health on the player")

    health.heal(heal_amount)