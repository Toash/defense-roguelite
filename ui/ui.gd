extends CanvasLayer

# wires player behaviour stuff onto the UI


@export var player: Node2D
# @export var hotbar_input: HotbarInput


@export var hotbar_ui: HotbarUI
@export var health_bar: ProgressBar
# @export 


func _ready() -> void:
	var player_health: Health = player.get_node_or_null("Health") as Health
	if not player_health: push_error("UI: player health not found")

	player_health.health_changed.connect(_on_health_changed)

	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health


	var hotbar_input: HotbarInput = player.get_node_or_null("HotbarInput") as HotbarInput
	if not hotbar_input: push_error("UI: Could not find hotbar input in player")
	hotbar_input.equip_slot.connect(hotbar_ui.on_equip_slot)

func _on_health_changed(health: int):
	health_bar.value = health
