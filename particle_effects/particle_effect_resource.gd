extends Resource


class_name ParticleEffectResource


## scene of particle effect, should be of type GPUParticles2D
@export var gpu_particles_2d_scene: PackedScene


@export_group("ParticleEffect Manager managed")
## the parent node the effect should be a child of, should exist in the gpu_particle_effect_2d_scene.
@export var parent_node: NodePath
## the offset from the parent_node
@export var position: Vector2