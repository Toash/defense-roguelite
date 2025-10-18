extends ItemEffect

class_name ProjectileEffect

@export var bullet: PackedScene
@export var damage = 25
@export var speed = 200


func apply(context: ItemContext):
    var bullet_inst: Bullet = bullet.instantiate() as Bullet
    # set parameters 
    bullet_inst.damage = damage
    bullet_inst.speed = speed
    bullet_inst.add_collision_exception_with(context.user_node)

    bullet_inst.global_position = context.spawn_point
    bullet_inst.look_at(context.target_point)

    context.root_node.add_child(bullet_inst)
