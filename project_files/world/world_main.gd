extends Node2D

@onready var timer_day_night = $timers/timer_day_night

@onready var player = $player

@onready var ship_0 = $ships/ship_0

@onready var enemy_spawn_timer = $timers/enemy_spawn_timer
@onready var ended_game = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_ship_sign()
	globs.play_intro_animation.connect(intro_crash)
	globs.player_danger_change.connect(player_danger_change)
	globs.play_win_cutscene.connect(play_win_cutscene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if Input.is_action_just_pressed("ctrl") and !globvars.played_intro_already: intro_crash()
	if ended_game: enemy_spawn_timer.stop()
	if globvars.IN_MENU and !timer_day_night.is_paused(): # Pauses
		timer_day_night.paused = true
	elif !globvars.IN_MENU and timer_day_night.is_paused(): # Unpauses
		timer_day_night.paused = false

func set_up_ship_sign():
	$ships/sign_locations/HBoxContainer/VBoxContainer/loc_0.text = str($ships/ship_0.global_position)
	$ships/sign_locations/HBoxContainer/VBoxContainer/loc_1.text = str($ships/ship_1.global_position)
	$ships/sign_locations/HBoxContainer/VBoxContainer/loc_2.text = str($ships/ship_2.global_position)
	$ships/sign_locations/HBoxContainer/VBoxContainer2/loc_3.text = str($ships/ship_3.global_position)
	$ships/sign_locations/HBoxContainer/VBoxContainer2/loc_4.text = str($ships/ship_4.global_position)
	$ships/sign_locations/HBoxContainer/VBoxContainer2/loc_5.text = str($ships/ship_5.global_position)
	
	
	
func intro_crash():
	globvars.played_intro_already = true
	player.visible = false
	globvars.STOP_PLAYER = true
	
	player.play_land_sfx()
	var land_pos = ship_0.global_position
	var tween = create_tween()
	tween.tween_property(player, 'global_position', land_pos, 2.6)
	
	globs.emit_signal('screen_shake', 40, 2.6)
	
	ship_0.ship_setup()
	await globs.ship_crashed
	print('crashed')
	
	
	player.visible = true
	globvars.STOP_PLAYER = false

func play_win_cutscene():
	ended_game = true
	player.global_position = $cutscene_win/cutscene_tele.global_position
	

# Changes Day Night Cycle Timer, emits signal 'change_day_night'
func _on_timer_day_night_timeout():
	if !globvars.IS_DAY: ## Turn to day
		globvars.IS_DAY = true
	else: ## Turn to night
		globvars.IS_DAY = false
	
	globs.emit_signal('change_day_night')
	globvars.day_night_time_left = 0


func _on_tick_timer_timeout():
	globvars.day_night_time_left = timer_day_night.time_left

### Enemy Spawning Stuff ###
func player_danger_change(in_darkness: bool):
	if in_darkness: enemy_spawn_timer.start()
	else: enemy_spawn_timer.stop()
func _on_enemy_spawn_timer_timeout():
	var skele_load = load("res://enemies/skeleton.tscn")
	var instance = skele_load.instantiate()
	instance.global_position = $player/spawners_enemy.get_random_spawn_pos()
	add_child(instance)
	print('added: ', instance)
