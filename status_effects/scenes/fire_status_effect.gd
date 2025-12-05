extends TickBased


class_name FireStatusEffect

var damage: int = 10

func _on_enter(pawn: Pawn):
    super._on_enter(pawn)

func _process(delta):
    super._process(delta)

func _on_tick(pawn: Pawn):
    pawn.health.damage(status_effect_data.get_status_effect_data("damage"))

func _on_exit(pawn: Pawn):
    super._on_exit(pawn)