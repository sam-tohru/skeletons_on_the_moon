extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.menu_screen.connect(menu_screen)

func menu_screen():
	
	if !globvars.played_intro_already:
		globs.emit_signal('play_intro_animation')
	
	reset_menu()
	self.visible = !self.visible
	globvars.IN_MENU = self.visible
	
	## Might need to disable buttons / Close settings page (and other pages that are open)

func reset_menu():
	pass

func _on_menu_pressed():
	globs.emit_signal('menu_screen')


func _on_settings_pressed():
	var setting_page = load("res://menu/settings_bg.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)


func _on_reset_pressed():
	globs.emit_signal('screen_shake', 50)
	globs.restart_game()


func _on_menu_2_pressed():
	return
	
	var setting_page = load("res://menu/info_page.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)
