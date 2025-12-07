# AudioManager.gd  (autoload)
extends Node


@export_group("Footsteps")
@export var grass_step: Array[AudioStream]

@export_group("Weapons")
@export var pistol_shoot: Array[AudioStream]
@export var melee_swoosh: Array[AudioStream]
@export var knife_slice: Array[AudioStream]

@export_group("Humans")
@export var human_hurt: Array[AudioStream]

@export_group("Zombies")
@export var zombie_attack: Array[AudioStream]
@export var zombie_groan: Array[AudioStream]
@export var zombie_death: Array[AudioStream]

@export_group("Doors")
@export var wood_door_open: Array[AudioStream]
@export var wood_door_close: Array[AudioStream]


@export_group("Building")
@export var placeholder_place: Array[AudioStream]


enum KEY {
	NO_SOUND,
	STEP_GRASS,

	WEAPON_MELEE_SWOOSH,
	WEAPON_PISTOL_SHOOT,
	WEAPON_KNIFE_SLICE,

	HUMAN_HURT,

	ZOMBIE_ATTACK,
	ZOMBIE_GROAN,
	ZOMBIE_DEATH,

	DOOR_WOOD_OPEN,
	DOOR_WOOD_CLOSE,


	BUILDING_PLACEHOLDER
	}


const POOL_SIZE := 40
var _players: Array[AudioStreamPlayer2D]

# dont play the same sound key inbetween these intervals
const SAME_SOUND_COOLDOWN := 0.1
var _time_since_played_sound: Dictionary[int, float]

func _ready():
	for key in KEY.values():
		_time_since_played_sound[key] = 0
	for i in POOL_SIZE:
		var p := AudioStreamPlayer2D.new()
		p.autoplay = false
		add_child(p)
		_players.append(p)

func _process(delta):
	for key in _time_since_played_sound:
		_time_since_played_sound[key] += delta


func play(stream: AudioStream, volume_db: float, position: Vector2, bus := "Master") -> void:
	var p := _get_free_player()
	if p == null: return
	p.bus = bus
	p.stream = stream
	p.volume_linear = volume_db
	p.global_position = position
	p.play()

func play_key(key: KEY, volume_db: float, position: Vector2, bus := "Master") -> void:
	if _time_since_played_sound[key] < SAME_SOUND_COOLDOWN:
		return

	var streams: Array[AudioStream]
	match key:
		KEY.NO_SOUND:
			return
		KEY.STEP_GRASS:
			streams = grass_step
		KEY.WEAPON_MELEE_SWOOSH:
			streams = melee_swoosh
		KEY.WEAPON_PISTOL_SHOOT:
			streams = pistol_shoot
		KEY.WEAPON_KNIFE_SLICE:
			streams = knife_slice

		KEY.HUMAN_HURT:
			streams = human_hurt

		KEY.ZOMBIE_ATTACK:
			streams = zombie_attack
		KEY.ZOMBIE_GROAN:
			streams = zombie_groan
		KEY.ZOMBIE_DEATH:
			streams = zombie_death

		KEY.DOOR_WOOD_OPEN:
			streams = wood_door_open
		KEY.DOOR_WOOD_CLOSE:
			streams = wood_door_close

		KEY.BUILDING_PLACEHOLDER:
			streams = placeholder_place
		_:
			push_error("Invalid key!")
			

	if streams.size() == 0: return
	var stream: AudioStream = streams[randi() % streams.size()]
		
	_time_since_played_sound[key] = 0
	
	play(stream, volume_db, position, bus)


func _get_free_player() -> AudioStreamPlayer2D:
	for p in _players:
		if not p.playing:
			return p
	return null
