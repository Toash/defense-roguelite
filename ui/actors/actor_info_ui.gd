## root node for displaying info about an actor
## ex. health , status effects
class_name ActorInfoUI
extends VBoxContainer


@export var root: Node

var vert_offset: float

var health_scene: PackedScene = preload("res://ui/health/health_ui.tscn")
var status_effects_ui_scene: PackedScene = preload("res://ui/status_effects/status_effects_ui.tscn")


func setup(vert_offset: float):
	## TODO implement vert offset
	self.vert_offset = vert_offset
	self.position.y = vert_offset


func add_health_ui(health: Health):
	var health_inst: HealthUI = health_scene.instantiate() as HealthUI
	health_inst.setup(health)
	root.add_child(health_inst)


func add_status_effects_ui(container: PawnStatusEffectContainer):
	var ui_inst: StatusEffectsUI = status_effects_ui_scene.instantiate() as StatusEffectsUI
	ui_inst.setup(container)
	root.add_child(ui_inst)
