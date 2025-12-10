extends CharacterBody2D

## Generic "Humanoid"
class_name Pawn

enum FACTION {
	NO_FACTION,
	HUMAN,
	ENEMY
}

@onready var world: World = get_tree().get_first_node_in_group("world") as World
@export var faction: FACTION


@export_group("References")
@export var health: Health
var character_sprite: CharacterSprite

var status_effect_container: PawnStatusEffectContainer

var raw_velocity: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2
var knockback_decay = 800


func _enter_tree() -> void:
	world = get_tree().get_first_node_in_group("world") as World
	_setup_status_effect_container()
	_setup_health()
	character_sprite = get_node("CharacterSprite")
	if character_sprite == null:
		push_error("Could not find character sprite!")
	

func _physics_process(delta: float) -> void:
	if knockback_velocity.length() > 0.0:
		knockback_velocity -= knockback_velocity.normalized() * knockback_decay * delta


func knockback(dir: Vector2, amount: float):
	# knockback_velocity = -1 * velocity.normalized()
	knockback_velocity = 1 * dir * amount


## do not multiply by delta
func set_raw_velocity(vel: Vector2):
	self.raw_velocity = vel


## multiply by delta
func get_total_velocity() -> Vector2:
	return raw_velocity + knockback_velocity

func _setup_health():
	self.health.died.connect(func():
		status_effect_container.clear_status_effects()
		)

func _setup_status_effect_container():
	status_effect_container = PawnStatusEffectContainer.new()
	status_effect_container.setup(self)
	self.add_child(status_effect_container)