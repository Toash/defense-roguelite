# DefenseUpgrade.gd
extends Resource
class_name DefenseUpgrade

@export var name: String
@export var description: String
@export var icon: Texture2D

@export var applies_to: Array[DefenseData.DEFENSE_TYPE]

# base states
@export_group("Base Stats")
@export var damage_mult: float = 0.0
@export var attack_speed_mult: float = 0.0
@export var health_mult: float = 0.0

@export_group("Effects")
@export var added_effects: Array[ItemEffect] = []


func get_base_stat_multiplier(base_stat: DefenseData.BASE_STAT) -> float:
    match base_stat:
        DefenseData.BASE_STAT.HEALTH:
            return health_mult
        DefenseData.BASE_STAT.DAMAGE:
            return damage_mult
        DefenseData.BASE_STAT.ATTACK_SPEED:
            return attack_speed_mult
        _:
            push_error("base stat not defined in defense upgrade!")
            return 1


func _to_string() -> String:
    return "Upgrade: " + name