extends PanelContainer

class_name DefenseStatDisplay


var runtime_defense: RuntimeDefense


@export var defense_label: Label

@export var base_stats_root: VBoxContainer
@export var effects_root: VBoxContainer


func setup(defense: RuntimeDefense):
	self.runtime_defense = defense

	defense_label.text = DefenseData.defense_type_to_string(defense.defense_data.defense_type)

	## todo: only get applicable base stats (from the item effects)
	for base_stat: DefenseData.BASE_STAT in defense.defense_data.BASE_STAT.values():
		var label = _get_base_stat_label(base_stat)
		base_stats_root.add_child(label)

	for effect: ItemEffect in defense.get_all_item_effects():
		var label = Label.new()
		label.text = effect.effect_name + ": " + effect.description
		effects_root.add_child(label)

func clear():
	runtime_defense = null
	defense_label.text = ""
	for child in base_stats_root.get_children():
		child.queue_free()
	for child in effects_root.get_children():
		child.queue_free()


func _get_base_stat_label(base_stat: DefenseData.BASE_STAT) -> Label:
	var stat_name: String = DefenseData.base_stat_to_string(base_stat)
	var base_stat_val := runtime_defense.defense_data.get_base_stat(base_stat)
	var upgrade_modifier_val := runtime_defense.get_total_additive_base_stat_modifier(base_stat)

	var stat_string = str(base_stat_val)
	if upgrade_modifier_val > 0:
		stat_string += " ( +"
		stat_string += str(upgrade_modifier_val)
		stat_string += " )"


	var string = stat_name + ": " + stat_string
	var label = Label.new()
	label.text = string
	return label
