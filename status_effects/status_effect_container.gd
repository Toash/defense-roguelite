extends Node2D

class_name PawnStatusEffectContainer

signal added_status_effect(node: RuntimePawnStatusEffect)
signal removed_status_effect(node: RuntimePawnStatusEffect)

var pawn: Pawn
var _status_effect_counts: Dictionary[RuntimePawnStatusEffect.TYPE, int] = {}

## call this before adding the node to the scenetree.
func setup(pawn: Pawn):
	self.pawn = pawn

func _ready():
	if pawn == null:
		push_error("PawnStatusEffectContainer: Pawn not defined")

	for type in RuntimePawnStatusEffect.TYPE.values():
		_status_effect_counts[type] = 0


func _process(delta):
	print(_status_effect_counts)


func add_status_effect(node: RuntimePawnStatusEffect):
	add_child(node)
	added_status_effect.emit(node)
	_status_effect_counts[node.data.type] += 1
	node.removed_status_effect.connect(func():
		removed_status_effect.emit(node)
		_status_effect_counts[node.data.type] -= 1
		)


func clear_status_effects():
	for status_effect: RuntimePawnStatusEffect in get_children():
		status_effect._on_exit(pawn)
		status_effect.call_deferred("queue_free")

	# for type in RuntimePawnStatusEffect.TYPE.values():
	#     _status_effect_counts[type] = 0

## returns dict count of status effects
func get_status_effects() -> Dictionary[RuntimePawnStatusEffect.TYPE, int]:
	return _status_effect_counts
