extends CanvasLayer

# wires player behaviour stuff onto the UI


# @export var hotbar_input: HotbarInput


@export_group("UI references")
@export var inventory_window: ExpandableWindow
@export var pickup_window: ExpandableWindow
@export var world_container_window: ExpandableWindow
@export var crafting_window: ExpandableWindow

@export var hotbar_ui: HotbarUI
@export var health_bar: ProgressBar
@export var coins_label: Label
@export var death_ui: DeathUI

@export var game_state_ui: GameStateUI

@export var offscreen_indicators: OffscreenIndicators

@export_group("World references")
@export var world: World
@export var player: Player
@export var game_state: GameState
@export var game_over: GameOver
@export var nexus: Nexus


func _ready() -> void:
	var player_health: Health = player.get_health()
	player_health.health_changed.connect(_on_health_changed)
	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health


	coins_label.text = "Coins: " + str(player.coins.current_coins)
	player.coins.coins_changed.connect(func(new_amount: int):
		coins_label.text = "Coins: " + str(new_amount)
		)


	game_over.game_over.connect(func():
		death_ui.show()
		)


	# attach containers to the uis 
	hotbar_ui.container = player.get_hotbar()
	(inventory_window.get_content() as ContainerUI).container = player.get_inventory()
	(pickup_window.get_content() as ContainerUI).container = player.get_pickups()
	# setup the uis
	hotbar_ui.setup()
	(inventory_window.get_content() as ContainerUI).setup()
	(pickup_window.get_content() as ContainerUI).setup()

	var hotbar_input: HotbarInput = player.get_hotbar_input()
	hotbar_input.equip_slot.connect(hotbar_ui.on_equip_slot)


	# Show container ui when opening container.
	var world_container_input: WorldContainerInput = player.get_world_container_input()

	world_container_input.container_interacted.connect(_on_container_interact)
	world_container_input.container_changed.connect(_on_container_changed)


	var crafting_ui: CraftingUI = crafting_window.get_content() as CraftingUI
	crafting_ui.update(player.get_player_crafting().get_blueprints())
	crafting_ui.blueprint_craft.connect(_on_blueprint_craft)

	game_state_ui.game_state = game_state


	offscreen_indicators.camera = player.camera
	world.generated_spawn_nodes.connect(func(nodes: Array[Node2D]):
		offscreen_indicators.set_targets(nodes)
		)


func _on_health_changed(health: int):
	health_bar.value = health


func _on_container_interact(item_container: ItemContainer):
	_set_world_container_ui(item_container)
	world_container_window.toggle()

func _on_container_changed(item_container: ItemContainer):
	_set_world_container_ui(item_container)


func _set_world_container_ui(item_container: ItemContainer):
	var container_ui: ContainerUI = world_container_window.get_content() as ContainerUI
	if container_ui == null:
		push_error("UI: Could not find Container UI in the world container window")

	container_ui.container = item_container
	container_ui.setup()

func _on_blueprint_craft(blueprint: Blueprint):
	player.get_player_crafting().craft(blueprint)
