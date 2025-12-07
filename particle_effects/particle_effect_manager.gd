## ParticleEffectManager (Autoload)
extends Node2D


# class_name ParticleEffectManager


func play_effect(resource: ParticleEffectResource):
    var effect: GPUParticles2D = resource.gpu_particle_effect_2d_scene.instantiate()
    if effect == null:
        push_error("ParticleEffectManager: spawned particle should be of type GPUParticles2D!")

    var parent_node: Node2D = get_node(resource.parent_node)
    parent_node.add_child(effect)
    effect.position = parent_node.position

    # connect to finished
    effect.finished.connect(func():
        effect.queue_free()
        )
