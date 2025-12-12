## container class for particle effects.
## passed into particle effect manager.
class_name ParticleEffect
extends RefCounted


var resource: ParticleEffectResource

var parent_node: NodePath
var local_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var rotation: float