extends Node2D

@onready var area_2d = $Area2D

@onready var animation_breaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Breaking section ## 
func _input(event):
	if event.is_action_pressed("skip") and !animation_breaking: check_and_brake()

func check_and_brake():
	if area_2d.has_overlapping_bodies():
		for area in area_2d.get_overlapping_bodies():
			if area.is_in_group('player'): player_interaction()

func player_interaction():
	
	if globvars.collected_things >= globvars.max_collected_things:
		print('DESTROY THE SKELETON')
		destroy_skeleton()
	else:
		print('NOT DONE YET!!')

func destroy_skeleton():
	globs.emit_signal('destroy_skeleton', global_position)
	
	var tween = create_tween()
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	
	tween.tween_property(self, 'rotation_degrees', 20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
	tween.tween_property(self, 'rotation_degrees', -20, 0.05)
	tween.tween_property(self, 'rotation_degrees', 0, 0.05)
