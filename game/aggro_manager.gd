extends Node2D


## controls the amount of enemies that can be aggroed onto the player.
class_name AggroManager


@export var max_aggroers: int = 6
var aggroers: Array[RuntimeEnemy]

const RELEASE_DELAY = 2
## returns true if can aggro and registers to aggroers.
func can_aggro(enemy: RuntimeEnemy) -> bool:
	if aggroers.size() >= max_aggroers: return false

	if aggroers.has(enemy):
		return true

	aggroers.append(enemy)
	return true


func release_aggro(enemy: RuntimeEnemy):
	if aggroers.has(enemy):
		await get_tree().create_timer(RELEASE_DELAY).timeout
		aggroers.erase(enemy)
