extends Node2D


## ensure that this is a direct child of the main node and not renamed. 
## ( lots of components are checking if this a direct child.)
class_name Health

signal died
signal health_changed(new_value)

signal got_hit()

## called damage with a hit context passed in
# signal hit_from_direction(dir: Vector2)
# signal hit_from_pawn(pawn: Pawn)


@export var max_health: int = 100
@onready var health: int = max_health

var owner_node

const bar_width := 40
const bar_height := 6

func _init(health: int = 100, max_health: int = 100):
	self.health = health
	self.max_health = max_health
func _ready():
	owner_node = get_parent()


func to_dict() -> Dictionary:
	return {
		"health": self.health,
		"max_health": self.max_health
	}

func from_dict(dict: Dictionary) -> void:
	self.health = dict.health
	self.max_health = dict.max_health


func damage(amount: int):
	var hit_context := HitContext.damage_only(amount)
	apply_hit(hit_context)

func apply_hit(hit_context: HitContext):
	if hit_context.hitter:
		var hitter_faction: Faction.Type
		var owner_faction: Faction.Type

		if hit_context.hitter.has_method("get_faction"):
			hitter_faction = hit_context.hitter.get_faction()
		else:
			hitter_faction = Faction.Type.NEUTRAL
			

		if owner_node.has_method("get_faction"):
			owner_faction = owner_node.get_faction()
		else:
			owner_faction = Faction.Type.NEUTRAL

		if not Faction.can_hit(hitter_faction, owner_faction):
			return
			
	TextPopupManager.damage_popup(str(hit_context.base_damage), global_position)
	if health <= 0: return

	health = clamp(health - hit_context.base_damage, 0, max_health)

	health_changed.emit(health)
	got_hit.emit(hit_context)

	if health <= 0:
		died.emit()


func heal(amount: float):
	if health <= 0: return

	health = clamp(health + amount, 0, max_health)
	health_changed.emit(health)

func set_health(health: int) -> void:
	self.health = health

func set_max_health(h: int) -> void:
	self.max_health = h

func get_health() -> int:
	return self.health

func get_max_health() -> int:
	return self.max_health

func get_ratio() -> float:
	var ratio: float = float(health) / max_health
	return ratio
