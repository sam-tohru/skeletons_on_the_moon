extends Area2D

@onready var sprites_crash = $sprites_crash
@onready var sprites = $sprites

@onready var fly_counter = 0

@onready var crash_1 = $particles/crash_1
@onready var crash_2 = $particles/crash_2
@onready var crash_3 = $particles/crash_3
@onready var crash_4 = $particles/crash_4

@onready var animation_breaking = false

@onready var curr_break = 0
@onready var max_break = 3
@onready var open_1 = $particles/open_1
@onready var open_2 = $particles/open_2
@onready var open_3 = $particles/open_3
@onready var open_4 = $particles/open_4
@onready var final_open = $particles/final_open
@onready var final_open_2 = $particles/final_open2
@onready var final_open_3 = $particles/final_open3

@export var player_ship: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !player_ship: 
		var rand_spawn_time = randf_range(3.0,6.0)
		print(rand_spawn_time)
		await get_tree().create_timer(rand_spawn_time).timeout
		ship_setup()

func ship_setup():
	var placed_pos = self.global_position
	
	self.global_position = Vector2(global_position[0]-450, global_position[1]-450)
	self.visible = true
	fly_movement(placed_pos)
	fly_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fly_movement(pos_vec: Vector2):
	var pos_0 = self.global_position[0]+450
	var pos_1 = self.global_position[1]+450
	
	var tween = create_tween()
	tween.tween_property(self, 'global_position', pos_vec, 2.4)
func fly_animation(): 
	var tween = create_tween()
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_property(sprites, 'rotation_degrees', randi_range(12,14), 0.05)
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-14), 0.05)
	
	tween.tween_callback(crash_animation)
func crash_animation():
	if fly_counter < 3: 
		fly_counter += 1
		fly_animation()
		return
	
	if player_ship: globs.emit_signal('ship_crashed')
	
	crash_1.emitting = true
	crash_2.emitting = true
	crash_3.emitting = true
	crash_4.emitting = true
	
	## Crash tween animation
	var tween = create_tween()
	tween.tween_property(sprites, 'rotation_degrees', 0, 0.05)
	tween.parallel().tween_property(sprites_crash, 'visible', true, 0.00)
	tween.tween_property(self, 'rotation_degrees', randi_range(-6,6), 0.05)
	tween.tween_property(sprites, 'visible', false, 0.00)


## Breaking section ## 
func _input(event):
	if event.is_action_pressed("skip") and !animation_breaking: check_and_brake()

func check_and_brake():
	if self.has_overlapping_bodies():
		for area in self.get_overlapping_bodies():
			if area.is_in_group('player'): break_open()

func final_break():
	animation_breaking = true
	final_open.emitting=true
	final_open_2.emitting=true
	final_open_3.emitting=true
	
	var inner = $explode/inner
	var part_0 = $explode/part0
	var part_1 = $explode/part1
	var part_2 = $explode/part2
	var explode = $explode
	
	explode.visible = true 
	sprites_crash.visible = false
	
	var expl_speed = 0.8
	
	var tween = create_tween()
	tween.tween_callback(globs.emit_signal.bind('destroyed_ship'))
	tween.tween_callback(globs.emit_signal.bind('break_sfx'))
	tween.tween_property(part_0, 'rotation_degrees', randi_range(125, 285), expl_speed)
	tween.parallel().tween_property(part_0, 'global_position', Vector2(part_0.global_position[0]+randi_range(-250, 250), part_0.global_position[1]+randi_range(-150, 150)), expl_speed)
	tween.parallel().tween_property(part_1, 'rotation_degrees',randi_range(125, 285), expl_speed)
	tween.parallel().parallel().tween_property(part_1, 'global_position', Vector2(part_1.global_position[0]+randi_range(-250, 250), part_1.global_position[1]+randi_range(-150, 150)), expl_speed)
	tween.parallel().tween_property(inner, 'rotation_degrees', randi_range(125, 285), expl_speed)
	tween.parallel().tween_property(inner, 'global_position', Vector2(inner.global_position[0]+randi_range(-250, 250), inner.global_position[1]+randi_range(-150, 150)), expl_speed)
	tween.parallel().tween_property(inner, 'scale', Vector2(0.6, 0.6), expl_speed)
	tween.parallel().tween_property(part_1, 'scale', Vector2(0.6, 0.6), expl_speed)
	tween.parallel().tween_property(part_0, 'scale', Vector2(0.6, 0.6), expl_speed)
	tween.tween_interval(0.6)
	tween.tween_callback(queue_free)
func break_open():
	globs.emit_signal('screen_shake', 10, 0.4)
	globs.emit_signal('sfx_punch', curr_break)
	animation_breaking = true
	
	var ani_crash = [open_1, open_2, open_3, open_4]
	
	curr_break += 1
	if curr_break >= ani_crash.size(): final_break() ; return
	
	print(curr_break, ' | ', ani_crash.size())
	ani_crash[curr_break].emitting = true
	
	
	var tween = create_tween()
	tween.tween_property(self, 'rotation_degrees', 25, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -25, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_callback(switch_back_ani_breaking)
func switch_back_ani_breaking():
	animation_breaking = false
