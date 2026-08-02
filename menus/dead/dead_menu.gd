extends BaseMenu
class_name DeadMenu

var death_messages = []
@onready var death_message: RichTextLabel = $MarginContainer/DeathMessage

func _ready() -> void:
	load_death_messages()
	set_random_death_message(DeathManager.last_death_type)

func load_death_messages() -> void:
	var file = FileAccess.open("res://menus/dead/assets/death_messages.json", FileAccess.READ)
	if file == null:
		printerr("Failed to locate list of death messages! Did you delete it like a dumbass?")
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		printerr("JSON parse error: ", json.get_error_message())
		return
	
	death_messages = json.data

func get_random_death_message(filter_type: String = "") -> String:
	if death_messages.is_empty(): # fallback if we can't load it
		return "You have perished."
	
	var pool = death_messages
	if filter_type:
		pool = death_messages.filter(func(d): return d.get("type") == filter_type)
		if pool.is_empty():
			return get_random_death_message() # fallback to default
	else:
		pool = death_messages.filter(func(d): return d.get("type") == "generic")
	
	var chosen = pool.pick_random()
	return chosen["text"]

func set_random_death_message(cause_of_death: String) -> void:
	death_message.text = get_random_death_message(cause_of_death)

## Buttons

func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/title/title.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/title/title.tscn")
