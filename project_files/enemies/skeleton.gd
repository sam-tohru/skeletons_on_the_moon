extends CharacterBody2D

@onready var sprites = $sprites
@onready var inner = $sprites/inner
@onready var outter = $sprites/outter

@onready var timer = $Timer

const SPEED = 30.0

@onready var state_machine = ['surround', 'attack', 'hit']
@onready var state = 'surround'

var randomnum
var target

@onready var player_area = $player_area

@onready var crash_1 = $particles/crash_1
@onready var crash_2 = $particles/crash_2

@onready var death_animation_playing = false
@onready var collision_shape_2d = $CollisionShape2D



# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	target = get_circle_position(randomnum)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ctrl"):kill_skeleton()
	if !check_for_darkness():
		if !death_animation_playing: kill_skeleton()
		return
	
	match state:
		'surround':
			target = get_circle_position(randomnum)
			move(target, delta)
func check_for_darkness() -> bool:
	if globvars.IS_DAY: return false
	
	
	if player_area.has_overlapping_areas():
		for area in player_area.get_overlapping_areas():
			if area.is_in_group('light_area'): return false
	
	
	return true


func move_animation():
	var frame_to_goto = 0
	if inner.frame == frame_to_goto: frame_to_goto = 1
	
	var tween = create_tween()
	tween.tween_property(sprites, 'rotation_degrees', randi_range(-12,-18), 0.2)
	tween.tween_property(inner, 'frame', frame_to_goto, 0.00)
	tween.parallel().tween_property(outter, 'frame', frame_to_goto, 0.00)
	tween.tween_property(sprites, 'rotation_degrees', 0, 0.2)

func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func get_circle_position(random):
	var killed_circle_centre = globvars.player_position
	var radius = 40
	var angle = random * PI * 2
	var x = killed_circle_centre.x + cos(angle) * radius
	var y = killed_circle_centre.y + sin(angle) * radius
	
	return Vector2(x,y)
	

func kill_skeleton():
	
	collision_shape_2d.disabled = true
	death_animation_playing = true
	crash_1.emitting = true
	crash_2.emitting = true
	var tween = create_tween()
	tween.tween_property(sprites, 'rotation_degrees', 900, 1.4)
	tween.parallel().tween_property(sprites, 'scale', Vector2(0.01,0.01), 1.4)
	
	tween.tween_callback(queue_free)

func _on_timer_timeout():
	move_animation()
