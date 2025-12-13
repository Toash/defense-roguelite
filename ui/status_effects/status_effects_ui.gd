extends VBoxContainer

## contains statuseffectui
class_name StatusEffectsUI


# func _add_status_effect(status_stack: StatusEffectGroup):
var ui_packed_scene: PackedScene = preload("res://ui/status_effects/status_effect_ui.tscn")
var status_effect_container: PawnStatusEffectContainer


func _ready():
	status_effect_container.status_effect_changed.connect(_on_change)

func setup(container: PawnStatusEffectContainer):
	self.status_effect_container = container


func _on_change(group: StatusEffectGroup):
	# look for existing
	for node in get_children():
		var ui: StatusEffectUI = node as StatusEffectUI
		if ui == null:
			push_error("children should be of type StatusEffectUI")
		var other_group: StatusEffectGroup = ui.status_group
		if group.equals(other_group):
			# update
			var new_effect = group.status_effect
			var new_amount = other_group.amount + group.amount
			var new_group := StatusEffectGroup.new(new_effect, new_amount)
			ui.set_status_effect_group(new_group)
			return

	# add a ui
	var ui_inst: StatusEffectUI = ui_packed_scene.instantiate() as StatusEffectUI
	ui_inst.setup(group)
	add_child(ui_inst)
