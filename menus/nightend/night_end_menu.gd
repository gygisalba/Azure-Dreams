extends BaseMenu

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_end_shift_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/title/title.tscn") ## todo: go to hub later
