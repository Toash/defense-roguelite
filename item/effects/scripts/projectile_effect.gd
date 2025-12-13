extends ItemEffect

class_name ProjectileEffect

@export var projectile_data: ProjectileData


# @export var pierce: int = 1

@export var shoot_audio_key: AudioManager.KEY
@export var shoot_volume: float = 1
@export var bus: String = "master"


func apply(context: ItemContext):
	var projectile_inst: ProjectileScene = projectile_data.packed_scene.instantiate() as ProjectileScene

	projectile_inst.global_position = context.global_spawn_point
	projectile_inst.look_at(context.global_target_position)
	projectile_inst.setup(context, projectile_data)
	context.root_node.add_child.call_deferred(projectile_inst)
	# print(shoot_volume)
	AudioManager.play_key(shoot_audio_key, shoot_volume, context.global_target_position, bus)
