extends Node2D

@onready var collect_fill_up = $collect_fill_up
@onready var collect_thing = $collect_fill_up/collect_thing
@onready var collect_label = $collect_fill_up/collect_label

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.destroyed_ship.connect(collected_thing)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func collected_thing():
	var og_pos = $collect_fill_up/marker_og.position
	
	globvars.collected_things += 1
	
	if globvars.collected_things > globvars.max_collected_things: 
		$collect_fill_up/collect_label/collect_done.visible = true
		return
	
	collect_label.text = str('Collect: ', globvars.collected_things, ' / 6')
	
	var tween = create_tween()
	tween.tween_property(collect_thing, 'modulate', Color(1, 1, 1, 1), 0.6)
	tween.parallel().tween_property(collect_thing, 'rotation_degrees', 720, 0.6)
	tween.tween_property(collect_thing, 'position', Vector2.ZERO, 0.2)
	tween.parallel().tween_property(collect_thing, 'rotation_degrees', 360, 0.2)
	
	tween.tween_property(collect_fill_up, 'rotation_degrees', randi_range(20,30), 0.1)
	tween.parallel().tween_property(collect_thing, 'modulate', Color(1, 1, 1, 0.0), 0.01)
	tween.parallel().tween_property(collect_fill_up, 'frame', globvars.collected_things, 0.01)
	tween.tween_property(collect_fill_up, 'rotation_degrees', 0, 0.1)
	
	
	tween.tween_property(collect_thing, 'position', og_pos, 0.01)
