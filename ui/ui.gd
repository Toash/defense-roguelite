extends CanvasLayer


@export var player: Node2D

@export var health_bar: ProgressBar


func _ready() -> void:
	var player_health: Health = player.get_node_or_null("Health") as Health
	if not player_health: push_error("player health not found from ui")

	player_health.health_changed.connect(_on_health_changed)

	health_bar.max_value = player_health.max_health
	health_bar.value = player_health.health

func _on_health_changed(health: int):
	health_bar.value = health
