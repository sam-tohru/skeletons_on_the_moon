extends Node

@onready var IN_MENU = true
@onready var STOP_PLAYER = false

@onready var volume = 0
@onready var music_volume = 0
@onready var drag_mode = false
@onready var gun_mode = false

@onready var mute_music = false
@onready var mute_sfx = false

@onready var played_intro_already = false

@onready var player_position = Vector2(0,0)
@onready var collected_things = 0
@onready var max_collected_things = 6

@onready var day_night_time_left = 0.0
@onready var IS_DAY : bool = true

func _ready():
	pass

func reset_vars():
	IN_MENU = true
	STOP_PLAYER = false
	
	volume = 0
	music_volume = 0
	drag_mode = false
	gun_mode = false
	
	mute_music = false
	mute_sfx = false
	
	played_intro_already = false
	
	player_position = Vector2(0,0)
	collected_things = 0
	
	day_night_time_left = 0.0
	IS_DAY = true
