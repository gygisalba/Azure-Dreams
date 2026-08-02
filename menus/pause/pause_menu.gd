extends MovingMenu
class_name PauseMenu

var paused : bool
signal pause_state_changed(state: bool)

func _ready() -> void:
	super()

func _on_resume_button_pressed() -> void:
	toggle_pause()

const OPTIONS_MENU = preload("uid://2gnht2qdfac3")
func _on_options_button_pressed() -> void:
	var options = OPTIONS_MENU.instantiate()
	add_child(options)

func _on_quit_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://menus/title/title.tscn")
	
func toggle_pause() -> void:
		paused = !paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = true
			show()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			queue_free()
		
		emit_signal("pause_state_changed", paused)
