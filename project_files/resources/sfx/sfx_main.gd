extends Node2D

@onready var sfx_volume = 0
@onready var bgm = $bgm

@onready var step = 0
@onready var max_step = 6
@onready var thump = $thumps/thump
@onready var thump_2 = $thumps/thump2
@onready var thump_3 = $thumps/thump3
@onready var thump_4 = $thumps/thump4
@onready var thump_5 = $thumps/thump5
@onready var thump_6 = $thumps/thump6

@onready var explosion = $explosion

@onready var ship_break = $ship_break

@onready var punch_0 = $punch0
@onready var punch_1 = $punch1
@onready var punch_2 = $punch2
@onready var punch_3 = $punch3


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.music_volume_changed.connect(music_volume_changed)
	globs.mute_music_signal.connect(mute_music_signal)
	globs.break_sfx.connect(break_sfx)
	globs.sfx_punch.connect(sfx_punch)
	
func break_sfx():
	if globvars.mute_sfx: return
	ship_break.set_volume_db(globvars.volume-10)
	ship_break.play()
func sfx_punch(num):
	if num > 3: num = 0
	if globvars.mute_sfx: return
	
	var punches = [punch_0, punch_1, punch_2, punch_3]
	punches[num].set_volume_db(globvars.volume-10)
	punches[num].play()
func play_thump():
	if globvars.mute_sfx: return
	var thumps = [thump, thump_2, thump_3, thump_4, thump_5, thump_6]
	thumps[step].set_volume_db(globvars.volume-20)
	thumps[step].play()
	print(thumps[step])
	step += 1
	if step >= max_step: step = 0

func play_explosion():
	if globvars.mute_sfx: return
	print('playing')
	explosion.set_volume_db(globvars.volume-20)
	explosion.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func music_volume_changed(new_value):
	bgm.set_volume_db(new_value-20)
	

func mute_music_signal():
	if globvars.mute_music: 
		bgm.stop()


func _on_bgm_finished():
	await get_tree().create_timer(randf_range(0.4, 0.9))
	bgm.play()



## Crash animation
@onready var land_me = $land_me
@onready var land_0 = $land_0
@onready var land_1 = $land_1
@onready var land_2 = $land_2


func play_land_0():
	if globvars.mute_sfx: return
	land_0.set_volume_db(globvars.volume-15)
	land_0.play()
func play_land_me():
	if globvars.mute_sfx: return
	land_me.set_volume_db(globvars.volume-15)
	land_me.play()
func play_land_1():
	if globvars.mute_sfx: return
	land_1.set_volume_db(globvars.volume-15)
	land_1.play()
func play_land_2():
	if globvars.mute_sfx: return
	land_2.set_volume_db(globvars.volume-15)
	land_2.play()
