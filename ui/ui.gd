extends CanvasLayer

# wires player behaviour stuff onto the UI


@export var player: Node2D
# @export var hotbar_input: HotbarInput


@export var hotbar_ui: HotbarUI
@export var health_bar: ProgressBar
@export var hunger_bar: ProgressBar
@export var thirst_bar: ProgressBar


func _ready() -> void:
	var player_health: Health = player.get_node_or_null("Health") as Health
	if not player_health: push_error("UI: player health not found")
	player_health.health_changed.connect(_on_health_changed)
	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health

	var player_hunger: DrainingStat = player.get_node_or_null("Hunger") as DrainingStat
	if not player_hunger: push_error("UI: player hunger not found")
	player_hunger.poll.connect(_on_hunger_poll)
	hunger_bar.max_value = player_hunger.max_stat
	hunger_bar.value = player_hunger.stat


	var player_thirst: DrainingStat = player.get_node_or_null("Thirst") as DrainingStat
	if not player_thirst: push_error("UI: player thirst not found")
	player_thirst.poll.connect(_on_thirst_poll)
	thirst_bar.max_value = player_thirst.max_stat
	thirst_bar.value = player_thirst.stat


	var hotbar_input: HotbarInput = player.get_node_or_null("HotbarInput") as HotbarInput
	if not hotbar_input: push_error("UI: Could not find hotbar input in player")
	hotbar_input.equip_slot.connect(hotbar_ui.on_equip_slot)

func _on_health_changed(health: int):
	health_bar.value = health

func _on_hunger_poll(hunger: int):
	hunger_bar.value = hunger

func _on_thirst_poll(thirst: int):
	thirst_bar.value = thirst
