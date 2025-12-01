extends Resource

class_name DefenseData

enum DEFENSE_TYPE {
    TURRET,
    BALLISTA,
    CANNON
}


## Upgrades look for these types, to apply the corresponding upgrade.

# @export var defense_type: DefenseData

@export_group("General")
@export var defense_priority: Defense.PRIORITY
@export var health: int = 100
@export var attack_damage: int = 10
@export var attack_speed: float = 2

@export_group("Behavior")
@export var base_effects: Array[ItemEffect] = []

@export_group("Upgrades")
@export var allowed_upgrades: Array[DefenseUpgrade]

@export_group("Projectiles")
@export var projectile_speed: float = 600
