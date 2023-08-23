extends Node2D

@onready var sprite_in = $in
@onready var sprite_out = $out

@export_range(1,4) var crater_number: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	print('sprite in string: ', str(crater_number), ' || sprite_animation: ', sprite_in.animation)
	
	if sprite_in.animation != str(crater_number): 
		sprite_in.animation = str(crater_number)
		sprite_out.animation = str(crater_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
