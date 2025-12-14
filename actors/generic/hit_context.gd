class_name HitContext
extends RefCounted

enum Key {
	DIRECTION,
	HITTER,
	BASE_DAMAGE,
	STATUS_EFFECTS,
	KNOCKBACK,
}

var direction_hit_from: Vector2
var hitter: Node2D
var base_damage: int
## array of StatusEffect
var status_effects: Array = []
var knockback_amount: float = 0.0

func _init(config: Dictionary) -> void:
	direction_hit_from = config.get(Key.DIRECTION, Vector2.ZERO)
	hitter = config.get(Key.HITTER, null)
	base_damage = config.get(Key.BASE_DAMAGE, 0)
	status_effects = config.get(Key.STATUS_EFFECTS, [])
	knockback_amount = config.get(Key.KNOCKBACK, 0.0)


## returns a damage only context.
static func damage_only(amount: int) -> HitContext:
	return HitContext.new({Key.BASE_DAMAGE: amount})


func is_directional() -> bool:
	return direction_hit_from != Vector2.ZERO
