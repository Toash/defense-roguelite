extends Resource


# specifies pawns that should spawn for a particular world
class_name WorldEnemies


@export var enemies: Array[EnemyData]


# gets random enemy data between min and max cost.
func get_random_enemy_data(min_cost: float, max_cost: float) -> EnemyData:
    var candidates: Array[EnemyData]

    for enemy_data: EnemyData in enemies:
        if enemy_data.cost <= max_cost and enemy_data.cost >= min_cost:
            candidates.append(enemy_data)

    if candidates.size() == 0: return null
    return candidates[randi() % candidates.size()]
