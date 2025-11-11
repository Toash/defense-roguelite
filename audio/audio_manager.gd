# AudioManager.gd  (autoload)
extends Node

@export_group("Footsteps")
@export var grass_step: Array[AudioStream]

@export_group("Weapons")
@export var pistol_shoot: Array[AudioStream]
@export var knife_slice: Array[AudioStream]

@export_group("Zombies")
@export var zombie_attack: Array[AudioStream]
@export var zombie_groan: Array[AudioStream]
@export var zombie_death: Array[AudioStream]


enum KEY {
	NO_SOUND,
	STEP_GRASS,

	WEAPON_PISTOL_SHOOT,
	WEAPON_KNIFE_SLICE,

	ZOMBIE_ATTACK,
	ZOMBIE_GROAN,
	ZOMBIE_DEATH,
	}

func play(stream: AudioStream, position: Vector2, bus := "Master") -> void:
	var p := AudioStreamPlayer2D.new()
	add_child(p)
	p.bus = bus
	p.stream = stream
	p.global_position = position
	p.finished.connect(p.queue_free)
	p.play()

func play_key(key: KEY, position: Vector2, bus := "Master") -> void:
	var streams: Array[AudioStream]
	match key:
		KEY.NO_SOUND:
			return
		KEY.STEP_GRASS:
			streams = grass_step
		KEY.WEAPON_PISTOL_SHOOT:
			streams = pistol_shoot
		KEY.WEAPON_KNIFE_SLICE:
			streams = knife_slice

		KEY.ZOMBIE_ATTACK:
			streams = zombie_attack
		KEY.ZOMBIE_GROAN:
			streams = zombie_groan
		KEY.ZOMBIE_DEATH:
			streams = zombie_death
		_:
			push_error("Invalid key!")
			
	var stream: AudioStream = streams[randi() % streams.size()]
		
	var p := AudioStreamPlayer2D.new()
	add_child(p)
	p.bus = bus
	p.stream = stream
	p.global_position = position
	p.finished.connect(p.queue_free)
	p.play()