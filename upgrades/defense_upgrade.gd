# DefenseUpgrade.gd
extends Upgrade
class_name DefenseUpgrade


@export var applies_to: Array[DefenseData.DEFENSE_TYPE]

@export_group("Base Stat Upgrades")
@export var damage_modifier: int = 0
@export var attack_speed_modifier: float = 0.0
@export var health_modifier: int = 0

@export_group("Effect Upgrades")
@export var added_effects: Array[ItemEffect] = []


func get_additive_base_stat_modifier(base_stat: DefenseData.BASE_STAT) -> float:
    match base_stat:
        DefenseData.BASE_STAT.HEALTH:
            return health_modifier
        DefenseData.BASE_STAT.DAMAGE:
            return damage_modifier
        DefenseData.BASE_STAT.ATTACK_SPEED:
            return attack_speed_modifier
        _:
            push_error("base stat not defined in defense upgrade!")
            return 1
