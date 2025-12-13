## container class for particle effects.
## passed into particle effect manager.
class_name ParticleEffect
extends RefCounted

enum Key {
    PACKED_SCENE,
    PARENT_NODE,
    POSITION,
    DIRECTION_VECTOR,
}

# var resource: ParticleEffectResource

## the packed scene of the particle to spawn.
var packed_scene: PackedScene

var parent_node: NodePath
var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT


func _init(
    config: Dictionary
) -> void:
    self.packed_scene = config.get(Key.PACKED_SCENE)
    self.parent_node = config.get(Key.PARENT_NODE)
    self.position = config.get(Key.POSITION, Vector2.ZERO)
    self.direction = config.get(Key.DIRECTION_VECTOR, Vector2.RIGHT)