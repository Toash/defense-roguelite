extends ItemEffect

class_name ZombieAttackEffect

@export var zombie_attack_scene: PackedScene
@export var attack_duration = 2
@export var damage = 25

func apply(context: ItemContext):
	var attack_inst: ZombieAttackScene = zombie_attack_scene.instantiate() as ZombieAttackScene


	attack_inst.context = context
	attack_inst.damage = damage
	attack_inst.duration = attack_duration

	
	# context.spawn_node.add_child.call_deferred(attack_inst)
	context.spawn_node.add_child.call_deferred(attack_inst)

	attack_inst.position = Vector2.ZERO
	# attack_inst.look_at(context.global_target_point)

	
	attack_inst.play.call_deferred(context.flipped)
