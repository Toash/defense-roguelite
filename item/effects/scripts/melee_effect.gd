extends ItemEffect

class_name MeleeEffect

@export var scene: PackedScene
@export var damage: int = 25

func apply(context: ItemContext):
	var melee_inst: MeleeScene = scene.instantiate() as MeleeScene

	melee_inst.finished.connect(func():
		context.equip_display.show_sprite()
		)

	melee_inst.setup(context, damage)
	context.spawn_node.add_child.call_deferred(melee_inst)
	melee_inst.play()
	
	context.equip_display.hide_sprite()
