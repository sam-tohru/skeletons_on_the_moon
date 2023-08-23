extends CharacterBody2D

@onready var sprite_guy = $sprite_guy
@onready var sprite_timer = $timers/sprite_timer

@onready var run_backward_sprites = [0, 1, 2, 3]
@onready var run_forward_sprites = [4, 5, 6, 7]
@onready var run_frame = 0

@onready var in_transit = false
@onready var flip_steps = false

@onready var flip_animation_playing = false
@onready var old_run_dir = 0

const SPEED = 180.0
const SPEED_SLOW_DOWN = 30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pos_container = $Camera2D/ui/pos_container

@onready var x_label = $Camera2D/ui/pos_container/HBoxContainer/x_label
@onready var y_label = $Camera2D/ui/pos_container/HBoxContainer/y_label
@onready var label_death = $sprite_death/label_death

@onready var menu = $Camera2D/menu

@onready var time_bar = $Camera2D/ui/time_bar
@onready var time_label = $Camera2D/ui/time_bar/Label

@onready var time_white = preload("res://resources/bars/time_bar.png")
@onready var time_night = preload("res://resources/bars/time_bar_fill.png")

@onready var tick_timer = $timers/tick_timer
@onready var player_area = $player_area

@onready var in_darkness: bool = false
@onready var ui = $Camera2D/ui
@onready var sfx_main = $sfx_main


@onready var playing_destroy_ani = false
func _ready():
	# globs.destroyed_ship.connect(destroyed_ship)
	globs.play_win_cutscene.connect(play_win_cutscene)
	globs.destroy_skeleton.connect(destroy_skeleton)
	
	if !menu.visible: menu.visible = true
func play_win_cutscene():
	ui.visible = false
	sprite_guy.visible = false
func destroy_skeleton(skele_pos: Vector2):
	if playing_destroy_ani: return
	playing_destroy_ani = true
	globvars.STOP_PLAYER = true
	var bomb_sprite = $bomb_sprite
	var bomb_scale = bomb_sprite.scale 
	bomb_sprite.scale = Vector2(0.01, 0.01)
	
	var expl_0 = $bomb_sprite/expl_0
	var expl_1 = $bomb_sprite/expl_1
	var expl_2 = $bomb_sprite/expl_2
	var expl_3 = $bomb_sprite/expl_3
	
	var tween = create_tween()
	tween.tween_property(sprite_guy, 'rotation_degrees', 35, 0.3)
	
	tween.tween_property(bomb_sprite, 'visible', true, 0.01)
	tween.tween_property(bomb_sprite, 'scale', bomb_scale, 0.3)
	tween.parallel().tween_property(bomb_sprite, 'rotation_degrees', 360, 0.3)
	
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.3)
	tween.parallel().tween_property(bomb_sprite, 'global_position', skele_pos, 0.6)
	tween.parallel().tween_property(bomb_sprite, 'rotation_degrees', 550, 0.6)
	tween.parallel().tween_callback(sfx_main.play_explosion)
	
	tween.tween_property(expl_0, 'emitting', true, 0.01)
	tween.tween_interval(0.05)
	tween.tween_property(expl_1, 'emitting', true, 0.01)
	tween.tween_interval(0.05)
	tween.tween_property(expl_2, 'emitting', true, 0.01)
	tween.tween_interval(0.05)
	tween.tween_property(expl_3, 'emitting', true, 0.01)
	tween.tween_interval(0.2)
	
	tween.tween_property(bomb_sprite, 'visible', false, 0.01)
	tween.tween_callback(globs.emit_signal.bind('play_win_cutscene'))
	
	# tween.tween_property(bomb_sprite, 'rotation_degrees', 720, 1.6)

func play_land_sfx():
	sfx_main.play_land_0()
	await get_tree().create_timer(0.3).timeout
	sfx_main.play_land_2()
	sfx_main.play_land_me()
	await get_tree().create_timer(2.2).timeout
	sfx_main.play_land_1()
func update_ui():
	if !globvars.IS_DAY: 
		time_bar.texture_under = time_white
		time_bar.texture_progress = time_night
		
		time_bar.value =  globvars.day_night_time_left
		time_label.text = 'Time left in Night'
	else: 
		time_bar.texture_under = time_night
		time_bar.texture_progress = time_white
		time_bar.value = globvars.day_night_time_left
		time_label.text = 'Time left in Day'

func _physics_process(delta):
	
	if globvars.IN_MENU or globvars.STOP_PLAYER:
		return
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var left_right = Input.get_axis("left", "right")
	var up_down = Input.get_axis("up", "down")
	
	if left_right:
		velocity.x = left_right * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_SLOW_DOWN)
	if up_down:
		velocity.y = up_down * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED_SLOW_DOWN)
	
	velocity = velocity.limit_length(SPEED)
	
	
	if !in_transit: 
		if left_right != 0 or up_down != 0: 
			move_from_stationary()
		
	
	if in_transit: move_and_slide()
	

### MOVEMENT STUFF ###
func update_pos_labels():
	x_label.text = str('x: ', snapped(self.global_position.x, 0.1))
	y_label.text = str('y: ', snapped(self.global_position.y, 0.1))
	globvars.player_position = self.global_position

	var defaul_pos = pos_container.position
	
	var tween = create_tween()
	tween.tween_property(pos_container, 'position', Vector2(pos_container.position[0]+randi_range(-4,4), pos_container.position[1]+randi_range(-4,4)), 0.05)
	tween.tween_property(pos_container, 'position', defaul_pos, 0.05)
	tween.tween_property(pos_container, 'position', Vector2(pos_container.position[0]+randi_range(-4,4), pos_container.position[1]+randi_range(-4,4)), 0.05)
	tween.tween_property(pos_container, 'position', defaul_pos, 0.05)

func move_from_stationary():
	
	var left_right = Input.get_axis("left", "right")
	var up_down = Input.get_axis("up", "down")
	
	sprite_timer.start()
	in_transit = true
	
	if left_right > 0 and !flip_animation_playing and sprite_guy.flip_h != true: 
		play_animation_flip(true)
	elif left_right < 0 and sprite_guy.flip_h != false and !flip_animation_playing:
		play_animation_flip(false)
	
	play_animation_run(up_down, left_right)
func _on_sprite_timer_timeout():
	var left_right = Input.get_axis("left", "right")
	var up_down = Input.get_axis("up", "down")
	
	if left_right == 0 and up_down == 0: 
		in_transit = false
		
	else: in_transit = true
	
	if left_right > 0 and !flip_animation_playing and sprite_guy.flip_h != true: 
		play_animation_flip(true)
	elif left_right < 0 and sprite_guy.flip_h != false and !flip_animation_playing:
		play_animation_flip(false)
	
	play_animation_run(up_down, left_right)
func play_animation_run(up_down, left_right):
	var run_frames = run_backward_sprites
	
	if up_down == 0 and left_right == 0: return
	elif up_down < 0: run_frames = run_forward_sprites
	
	if up_down != old_run_dir:
		old_run_dir = up_down
		play_animation_v_flip()
	
	var run_frame = randi_range(2,3)
	if run_frame == 2: run_frame -=1
	
	if flip_steps: run_frame = 1 ; flip_steps = false
	else: run_frame = 3 ; flip_steps = true
	
	#sprite_guy.frame = run_frames[run_frame]
	
	var tween = create_tween()
	tween.tween_property(sprite_guy, 'rotation_degrees', randi_range(-12,-18), 0.2)
	tween.tween_property(sprite_guy, 'frame', run_frames[run_frame], 0.00)
	tween.tween_interval(0.2)
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.2)
	tween.parallel().tween_callback(globs.emit_signal.bind('screen_shake', 4, 0.2))
	tween.parallel().tween_callback(sfx_main.play_thump)
	tween.tween_property(sprite_guy, 'frame', run_frames[0], 0.00)
	tween.tween_callback(update_pos_labels)
	
	
func play_animation_v_flip():
	var tween = create_tween()
	tween.tween_property(sprite_guy, 'rotation_degrees', randi_range(24,28), 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', randi_range(-24,-28), 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.02)
func play_animation_flip(going_to_flip_h):
	flip_animation_playing = true
	var tween = create_tween()
	tween.tween_property(sprite_guy, 'rotation_degrees', randi_range(24,28), 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.02)
	tween.parallel().tween_property(sprite_guy, 'flip_h', going_to_flip_h, 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', randi_range(-24,-28), 0.02)
	tween.tween_property(sprite_guy, 'rotation_degrees', 0, 0.02)
	tween.tween_callback(change_back_flip_ani_playing)
func change_back_flip_ani_playing():
	flip_animation_playing = false


## Death Stuff ##
func player_death():
	var sprite_death = $sprite_death
	var left = $sprite_death/sprite_left
	var right = $sprite_death/sprite_right
	
	var left_mark = $sprite_death/sprite_left/Marker2D
	var right_mark = $sprite_death/sprite_right/Marker2D
	
	var parts_death_1 = $sprite_death/sprite_left/parts_death_1
	var parts_death_2 = $sprite_death/parts_death_2
	var parts_death_3 = $sprite_death/sprite_right/parts_death_3
	
	#label_death.visible = true
	globvars.STOP_PLAYER = true
	sprite_death.visible = true
	sprite_guy.visible = false
	
	var tween = create_tween()
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(8,12), 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', 0, 0.1)
	tween.parallel().tween_property(sprite_death, 'frame', 1, 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(-8,-12), 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', 0, 0.1)
	tween.parallel().tween_property(sprite_death, 'frame', 2, 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(8,12), 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', 0, 0.1)
	tween.parallel().tween_property(sprite_death, 'frame', 3, 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(-8,-12), 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', 0, 0.1)
	tween.parallel().tween_property(sprite_death, 'frame', 4, 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(8,12), 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', 0, 0.1)
	tween.parallel().tween_property(sprite_death, 'frame', 5, 0.1)
	
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(-8,-12), 0.1)
	
	
	## Explosion ##
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(-12,-14), 0.05)
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprite_death, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(left, 'visible', true, 0.0)
	tween.parallel().tween_property(right, 'visible', true, 0.0)
	tween.tween_property(sprite_death, 'frame', 6, 0.0)
	
	tween.tween_property(parts_death_1, 'emitting', true, 0.0)
	tween.parallel().tween_property(parts_death_2, 'emitting', true, 0.0)
	tween.parallel().tween_property(parts_death_3, 'emitting', true, 0.0)
	
	tween.tween_property(left, 'position', left_mark.position, 1.8)
	tween.parallel().tween_property(left, 'rotation_degrees', 440, 1.8)
	tween.parallel().tween_property(right, 'position', right_mark.position, 1.8)
	tween.parallel().tween_property(right, 'rotation_degrees', 440, 1.8)

func throw_bomb():
	pass


func _on_tick_timer_timeout():
	
	if !in_darkness and check_for_darkness(): 
		in_darkness = true
		globs.emit_signal('player_danger_change', in_darkness)
	elif in_darkness and !check_for_darkness():
		in_darkness = false
		globs.emit_signal('player_danger_change', in_darkness)
	
	
	update_ui()

## Player area stuff, bodies & area detection ##
#checks if in darkness (is night & not in base)
func check_for_darkness() -> bool:
	if globvars.IS_DAY: return false
	
	
	if player_area.has_overlapping_areas():
		for area in player_area.get_overlapping_areas():
			if area.is_in_group('light_area'): return false
	
	
	return true
	

func _on_player_area_body_entered(body):
	if body.is_in_group('enemy') and !globvars.STOP_PLAYER: player_death()

func _on_player_area_area_entered(area):
	
	if area.is_in_group('out_of_area'):
		$Camera2D/ui/out_of_area_label.visible = true



func _on_player_area_area_exited(area):
	if area.is_in_group('out_of_area'):
		$Camera2D/ui/out_of_area_label.visible = false
