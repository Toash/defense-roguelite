extends Resource

## Static initial data for defenses
class_name DefenseData

enum DEFENSE_TYPE {
    TURRET,
    BALLISTA,
    CANNON
}

enum BASE_STAT {
    HEALTH,
    DAMAGE,
    ATTACK_SPEED,
    PROJECTILE_SPEED,
}


@export_group("General")
@export var defense_type: DEFENSE_TYPE
@export var defense_priority: RuntimeDefense.PRIORITY
@export var health: int = 100
@export var attack_damage: int = 10
@export var attack_cooldown: float = 2

@export_group("Behavior")
## The base functionality of this tower
@export var base_effects: Array[ItemEffect] = []

# @export_group("Upgrades")
# ## upgrades that are able to be applied on this tower.
# @export var allowed_upgrades: Array[DefenseUpgrade]

@export_group("Projectiles")
@export var projectile_speed: float = 600


func get_base_stat(base_stat: BASE_STAT) -> float:
    match base_stat:
        BASE_STAT.HEALTH:
            return health
        BASE_STAT.DAMAGE:
            return attack_damage
        BASE_STAT.ATTACK_SPEED:
            return attack_cooldown
        _:
            push_error("base_stat not specified")
            return 0

func _to_string() -> String:
    return "Tower: " + str(DEFENSE_TYPE.keys()[defense_type])