extends Node2D

@onready var spawn_0 = $spawn_0
@onready var spawn_1 = $spawn_1
@onready var spawn_2 = $spawn_2
@onready var spawn_3 = $spawn_3
@onready var spawn_4 = $spawn_4
@onready var spawn_5 = $spawn_5
@onready var spawn_6 = $spawn_6
@onready var spawn_7 = $spawn_7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_spawn_pos() -> Vector2:
	var all_spawn_pos = [spawn_0, spawn_1, spawn_2, spawn_3, spawn_4, spawn_5, spawn_6, spawn_7]
	return all_spawn_pos.pick_random().global_position
