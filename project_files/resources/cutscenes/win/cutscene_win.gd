extends Node2D

@onready var moon_sheet = $moon_sheet
@onready var expl_2 = $parts/expl_2
@onready var expl_0 = $parts/expl_0
@onready var expl_1 = $parts/expl_1
@onready var expl_4 = $parts/expl_4
@onready var expl_3 = $parts/expl_3

@onready var parts = $parts
@onready var expl_marker = $moon_sheet/expl_marker


@onready var sprite_timer = $moon_sheet/sprite_timer

@onready var label_2 = $Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.play_win_cutscene.connect(play_cutscene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_cutscene():
	globs.emit_signal('screen_shake', 25, 3)
	
	expl_2.emitting = true
	await get_tree().create_timer(0.05).timeout
	expl_0.emitting = true
	expl_1.emitting = true
	await get_tree().create_timer(0.05).timeout
	expl_4.emitting = true
	expl_3.emitting = true
	
	await get_tree().create_timer(0.6).timeout
	label_2.visible = true
	sprite_timer.start()
	var tween = create_tween()
	tween.tween_property(parts, 'global_position', expl_marker.global_position, 1.8)


func _on_sprite_timer_timeout():
	if moon_sheet.frame >= 31: moon_sheet.frame = 0
	else: moon_sheet.frame += 1
