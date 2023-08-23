extends ColorRect

@onready var volume_slider = $volume_slider
@onready var volume_indicator = $volume_slider/volume_indicator

@onready var music_slider = $music_slider
@onready var music_indicator = $music_slider/music_indicator


@onready var mute_music = $mute_music
@onready var mute_sfx = $mute_sfx


# Called when the node enters the scene tree for the first time.
func _ready():
	volume_slider.value = globvars.volume
	music_slider.value = globvars.music_volume
	indicator_animation()
	mute_music.button_pressed = globvars.mute_music
	mute_sfx.button_pressed = globvars.mute_sfx
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func indicator_music_animation():
	music_indicator.text = str(globvars.music_volume)
	
	var orig_scale = Vector2(1,1)
	var tween = create_tween()
	tween.tween_property(music_indicator, "rotation_degrees", 15, 0.05)
	tween.tween_property(music_indicator, "rotation_degrees", 0, 0.05)
	tween.tween_property(music_indicator, "rotation_degrees", -15, 0.05)
	tween.tween_property(music_indicator, "rotation_degrees", 0, 0.05)

func indicator_animation():
	volume_indicator.text = str(globvars.volume)
	
	var orig_scale = Vector2(1,1)
	var tween = create_tween()
	tween.tween_property(volume_indicator, "rotation_degrees", 15, 0.05)
	tween.tween_property(volume_indicator, "rotation_degrees", 0, 0.05)
	tween.tween_property(volume_indicator, "rotation_degrees", -15, 0.05)
	tween.tween_property(volume_indicator, "rotation_degrees", 0, 0.05)

func _on_settings_back_pressed():
	self.queue_free()


func _on_volume_slider_value_changed(value):
	globvars.volume = value
	globs.emit_signal('sfx_woosh')
	indicator_animation()

func _on_music_slider_value_changed(value):
	globvars.music_volume = value
	globs.emit_signal('music_volume_changed', value)
	indicator_music_animation()


func _on_mute_music_toggled(button_pressed):
	globvars.mute_music = button_pressed
	globs.emit_signal('mute_music_signal')


func _on_mute_sfx_toggled(button_pressed):
	globvars.mute_sfx = button_pressed
