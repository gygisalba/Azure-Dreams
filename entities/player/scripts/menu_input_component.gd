extends Node
class_name MenuInputComponent

const PAUSE_MENU_SCENE = preload("res://menus/pause/pause_menu.tscn")
var pause_menu : PauseMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if not pause_menu:
			pause_menu = PAUSE_MENU_SCENE.instantiate()
			get_tree().current_scene.add_child(pause_menu)
		
		pause_menu.toggle_pause()
