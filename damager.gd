extends Area2D


func _ready() -> void:
    body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D):
    var health = body.get_node_or_null("Health") as Health
    if health:
        health.damage(10)
