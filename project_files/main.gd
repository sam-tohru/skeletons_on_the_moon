extends Node2D

@onready var board = $board
@onready var spawn_timer = $board/spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("menu"):
		globs.emit_signal('menu_screen')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

