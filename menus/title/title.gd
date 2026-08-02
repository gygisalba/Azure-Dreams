extends BaseMenu
class_name TitleMenu

func _on_play_button_pressed() -> void:
	LoadingManager.load_scene("res://scenes/hub/hub_area.tscn")

const OPTIONS_MENU = preload("uid://2gnht2qdfac3")
func _on_options_button_pressed() -> void:
	var options = OPTIONS_MENU.instantiate()
	add_child(options)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	# do something funny with this later
