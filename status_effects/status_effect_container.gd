extends Node2D

## contains status effects that are currently on a pawn
class_name PawnStatusEffectContainer

# signal status_effects_added(status_effect: StatusEffectGroup)
# signal status_effects_removed(status_effect: StatusEffectGroup)
signal status_effect_changed(status_effect: StatusEffectGroup)

var pawn: Pawn
var _status_effect_counts: Dictionary[StatusEffect, int] = {}

## call this before adding the node to the scenetree.
func setup(pawn: Pawn):
	self.pawn = pawn

func _ready():
	if pawn == null:
		push_error("PawnStatusEffectContainer: Pawn not defined")

	for status_effect: StatusEffect in StatusEffectRegistry.get_all():
		print(status_effect)
		_status_effect_counts[status_effect] = 0
	

# func _process(delta):
# 	print(_status_effect_counts)


# func add_status_effect(node: RuntimePawnStatusEffect):
func add_status_effect(status_effect: StatusEffect):
	# add the runtime effect as a child to this container
	var runtime_effect: RuntimePawnStatusEffect = status_effect.packed_scene.instantiate() as RuntimePawnStatusEffect
	if runtime_effect == null:
		push_error("Pawn status effect packed_scene is not the correct type!")
		return
	runtime_effect.pawn = pawn
	runtime_effect.data = status_effect.data
	add_child(runtime_effect)

	status_effect_changed.emit(StatusEffectGroup.new(status_effect, 1))
	_status_effect_counts[status_effect] += 1

	runtime_effect.runtime_status_effect_ended_before_queue_free.connect(func(_runtime_node: RuntimePawnStatusEffect):
		status_effect_changed.emit(StatusEffectGroup.new(status_effect, -1))
		_status_effect_counts[status_effect] -= 1
		)


func clear_status_effects():
	for status_effect: RuntimePawnStatusEffect in get_children():
		status_effect._on_exit(pawn)
		status_effect.call_deferred("queue_free")

	# for type in StatusEffect.TYPE.values():
	#     _status_effect_counts[type] = 0


## returns dict count of status effects
# func get_status_effects() -> Dictionary[StatusEffect.TYPE, int]:
func get_status_effects() -> Array[StatusEffectGroup]:
	var ret: Array[StatusEffectGroup] = []
	for status_effect in _status_effect_counts:
		var stack = StatusEffectGroup.new(status_effect, _status_effect_counts[status_effect])
		ret.append(stack)
	return ret
