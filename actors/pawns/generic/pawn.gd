extends CharacterBody2D

## Generic "Humanoid"
class_name Pawn

@onready var world: World = get_tree().get_first_node_in_group("world") as World
@export var faction: Faction.Type


@export_group("References")
@export var health: Health
## effect to play when node is hit.
@export var directional_blood_scene: PackedScene = preload("res://particle_effects/directional_blood_effect.tscn")
@export var blood_scene: PackedScene = preload("res://particle_effects/blood_effect.tscn")

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

func get_faction() -> Faction.Type:
	return self.faction


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
	self.health.got_hit.connect(_on_hit)
		# apply status effect


	self.health.died.connect(func():
		status_effect_container.clear_status_effects()
		)

func _setup_status_effect_container():
	status_effect_container = PawnStatusEffectContainer.new()
	status_effect_container.setup(self)
	self.add_child(status_effect_container)


func _setup_status_effect_ui():
	pass


func _on_hit(hit_context: HitContext):
	if hit_context.hitter:
		if hit_context.hitter.has_method("get_faction"):
			var hitter_faction: Faction.Type = hit_context.hitter.get_faction()
			if not Faction.can_hit(hitter_faction, faction):
				return
		else:
			push_error("hitter should implement has_faction method.")


	if hit_context.direction_hit_from == Vector2.ZERO:
		# non directional
		var particle_effect := ParticleEffect.new({
			ParticleEffect.Key.PACKED_SCENE: blood_scene,
			ParticleEffect.Key.PARENT_NODE: get_path(),
		})
		ParticleEffectManager.play_particle_effect(particle_effect)
	else:
		# directional
		var particle_effect := ParticleEffect.new({
			ParticleEffect.Key.PACKED_SCENE: directional_blood_scene,
			ParticleEffect.Key.PARENT_NODE: get_path(),
			ParticleEffect.Key.DIRECTION_VECTOR: hit_context.direction_hit_from,
		})
		ParticleEffectManager.play_particle_effect(particle_effect)


	knockback(hit_context.direction_hit_from, hit_context.knockback_amount)

	# apply status effects
	for status_effect: StatusEffect in hit_context.status_effects:
		# status_effect.apply_status_effect_to_pawn(self)
		status_effect_container.add_status_effect(status_effect)
