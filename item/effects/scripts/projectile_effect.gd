extends ItemEffect

class_name ProjectileEffect

@export var projectile: PackedScene
@export var factions_to_hit: Array[Pawn.FACTION]
@export var damage = 25
@export var speed = 200

# @export var pierce: int = 1

@export var shoot_audio_key: AudioManager.KEY
@export var shoot_volume: float = 1
@export var bus: String = "master"


func apply(context: ItemContext):
    var projectile_inst: ProjectileScene = projectile.instantiate() as ProjectileScene

    var data: ProjectileData = ProjectileData.new()
    data.factions_to_hit = factions_to_hit
    data.damage = damage
    data.speed = speed
    data.context = context

    projectile_inst.global_position = context.global_spawn_point
    projectile_inst.look_at(context.global_target_position)

    projectile_inst.setup(data)

    context.root_node.add_child.call_deferred(projectile_inst)
    print(shoot_volume)
    AudioManager.play_key(shoot_audio_key, shoot_volume, context.global_target_position, bus)
