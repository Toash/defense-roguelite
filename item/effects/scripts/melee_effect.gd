extends ItemEffect

class_name MeleeEffect

# @export var melee_scene: PackedScene
# @export var factions_to_hit: Array[Pawn.FACTION]
# @export var damage: int = 25
# # how many enemies can be hit in one swing
# @export var pierce: int = 1
@export var melee_data: MeleeData

@export var shoot_audio_key: AudioManager.KEY
@export var shoot_volume: float = 1
@export var bus: String = "master"

func apply(context: ItemContext):
	var melee_inst: MeleeScene = melee_data.melee_scene.instantiate() as MeleeScene

	melee_inst.finished.connect(func():
		context.equip_display.show_sprite()
		)
	var data


	# melee_inst.setup(context, damage, pierce)
	melee_inst.setup(context, melee_data)

	context.spawn_node.add_child.call_deferred(melee_inst)
	melee_inst.play()
	
	context.equip_display.hide_sprite()
