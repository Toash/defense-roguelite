extends ItemEffect

class_name MeleeEffect

@export var melee: PackedScene
@export var damage = 25
@export var swing_speed = 5

func apply(context: ItemContext):
	var melee_inst: Melee = melee.instantiate() as Melee

	melee_inst.finished.connect(func():
		context.equip_display.show_sprite()
		)

	# melee_inst.global_position = context.spawn_point
	melee_inst.damage = damage
	melee_inst.swing_speed = swing_speed

	
	context.spawn_node.add_child.call_deferred(melee_inst)
	melee_inst.position = Vector2.ZERO
	melee_inst.look_at(context.global_target_point)


	melee_inst.play(context, context.flipped)
	context.equip_display.hide_sprite()
