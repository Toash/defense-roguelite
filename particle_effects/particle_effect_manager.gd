## ParticleEffectManager (Autoload)
extends Node2D


# class_name ParticleEffectManager


func play_particle_effect(particle_effect: ParticleEffect):
	var effect_node: GPUParticles2D = particle_effect.packed_scene.instantiate()
	if effect_node == null:
		push_error("ParticleEffectManager: spawned particle should be of type GPUParticles2D!")

	var parent: Node = get_node(particle_effect.parent_node)
	var local_position: Vector2 = particle_effect.position
	var direction: Vector2 = particle_effect.direction
	

	parent.add_child(effect_node)
	effect_node.position = local_position
	# effect_node.look_at(effect_node.to_global(effect_node.position + direction))
	effect_node.rotate(direction.angle())


	effect_node.restart()

	# connect to finished
	effect_node.finished.connect(func():
		effect_node.queue_free()
		)
