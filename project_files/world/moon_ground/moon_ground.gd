extends Node2D

@onready var dark_rect = $DarkRect
@onready var day_rect = $DayRect



# Called when the node enters the scene tree for the first time.
func _ready():
	globs.change_day_night.connect(change_day_night)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_day_night():
	var transparency_change = Color(1, 1, 1, 1)
	if !globvars.IS_DAY: # Changes ground to dark
		transparency_change = Color(1, 1, 1, 0.01)
	
	var tween = create_tween()
	tween.tween_property(day_rect, 'modulate', transparency_change, 0.4)
