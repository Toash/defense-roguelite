extends Area2D

## root node for all defenses 
class_name Defense

# How do other enemies see this ? 
enum PRIORITY {
	INVISIBLE,
	VISIBLE

}


@export var health: Health


# "on-paper data"
@export var defense_data: DefenseData


# runtime stats
var stat_multipliers := {
	"health": 1,
	"damage": 1.0,
	"fire_rate": 1.0,
	# "range": ,
}
var upgraded_defense_effects: Array[ItemEffect] = []

func add_item_effect(effect: ItemEffect):
	var dup = effect.duplicate()
	upgraded_defense_effects.append(dup)

# runtime getters
func get_health() -> int:
	return defense_data.health * stat_multipliers["health"]
	
func get_damage() -> int:
	return defense_data.attack_damage * stat_multipliers["damage"]

func get_fire_rate() -> float:
	return defense_data.attack_speed / stat_multipliers["fire_rate"]


func get_item_effects() -> Array[ItemEffect]:
	return defense_data.base_effects + upgraded_defense_effects


func _ready():
	if health != null:
		health.died.connect(func():
			queue_free()
			)
		health.max_health = defense_data.health
		health.health = defense_data.health


func get_data() -> DefenseData:
	return self.defense_data
