extends Resource

class_name DefenseData

@export_group("General")
@export var defense_priority: Defense.PRIORITY
@export var health: int = 100
@export var attack_damage: int = 10
@export var attack_speed: float = 2

@export_group("Projectiles")
@export var projectile_speed: float = 600
