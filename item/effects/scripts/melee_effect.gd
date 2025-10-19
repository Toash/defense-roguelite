extends ItemEffect

class_name MeleeEffect

@export var melee: PackedScene


func apply(context: ItemContext):
	var melee_inst: Melee = melee.instantiate() as Melee

	melee_inst.global_position = context.spawn_point
	melee_inst.look_at(context.target_point)

	melee_inst.play(context)
	
	context.root_node.add_child(melee_inst)
