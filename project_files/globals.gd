extends Node

signal menu_screen
signal music_volume_changed
signal mute_music_signal

signal sfx_woosh
signal sfx_punch
signal sfx_grunt
signal sfx_battle_done
signal sfx_firework
signal fight_animation

signal screen_shake
signal break_sfx

signal player_danger_change
signal destroyed_ship
signal destroy_skeleton

signal change_day_night
signal ship_crashed

signal play_intro_animation
signal play_win_cutscene

func _ready():
	pass
	
func restart_game():
	
	globvars.reset_vars()
	
	get_tree().reload_current_scene()
