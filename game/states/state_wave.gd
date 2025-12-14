extends State

## Wave state
## manages behaviour while a wave is in progress.
class_name WaveState


@export var spawn_manager: SpawnManager
@export var wave_time: float = 1

@export var world: World
var spawn_timer: float = 0
var wave_timer: float = 0

var wave_number: int = 0


func state_enter():
	spawn_timer = 0
	wave_timer = 0
	wave_number += 1
	TextPopupManager.popup("Wave " + str(wave_number) + " incoming...", (get_viewport_rect().size / 2) + Vector2.DOWN * 200)
	

func state_update(delta: float):
	spawn_timer += delta
	wave_timer += delta

	if spawn_timer > spawn_manager.spawn_delay:
		spawn_manager.spawn_at_random_spawn_node()
		spawn_timer = 0

	if wave_timer > wave_time:
		transitioned.emit(self, "intermission")
		

func state_physics_update(delta: float):
	pass

func state_exit():
	pass
