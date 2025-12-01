# DefenseUpgrade.gd
extends Resource
class_name DefenseUpgrade

@export var id: StringName
@export var name: String
@export var description: String
@export var icon: Texture2D

# stat modifiers (additive/multipliers – up to you)
@export var damage_mult: float = 0.0
@export var fire_rate_mult: float = 0.0
@export var range_mult: float = 0.0
@export var health_mult: float = 0.0

# behavior: effects to add
@export var add_effects: Array[ItemEffect] = []

func apply_to_defense(defense: Defense) -> void:
    # stats
    if damage_mult != 0.0:
        defense.stat_multipliers["damage"] += damage_mult
    if fire_rate_mult != 0.0:
        defense.stat_multipliers["fire_rate"] += fire_rate_mult
    if range_mult != 0.0:
        defense.stat_multipliers["range"] += range_mult
    if health_mult != 0.0:
        defense.stat_multipliers["health"] += health_mult
        # if you want, also bump current health here

    # effects
    for effect in add_effects:
        defense.add_upgrade_item_effect(effect)
