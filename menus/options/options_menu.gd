extends MovingMenu
class_name options_menu

@onready var master_volume_slider: VSlider = %MasterVolumeSlider
@onready var sfx_volume_slider: VSlider = %SFXVolumeSlider
@onready var music_volume_slider: VSlider = %MusicVolumeSlider
@onready var drill_volume_slider: VSlider = %DrillVolumeSlider
@onready var close_menu_button: Button = %CloseMenuButton

const BUS_MASTER := "Master"
const BUS_SFX    := "SFX"
const BUS_MUSIC  := "Music"
const BUS_DRILL  := "Drill"

const SAVE_PATH := "res://userdata/settings/volume_settings.cfg"
var config := ConfigFile.new()

func _ready() -> void:
	super()
	load_volumes()

func _on_master_volume_slider_value_changed(value: float) -> void:
	set_bus_volume(BUS_MASTER, value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	set_bus_volume(BUS_SFX, value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	set_bus_volume(BUS_MUSIC, value)
	
func _on_drill_volume_slider_value_changed(value: float) -> void:
	set_bus_volume(BUS_DRILL, value)

func set_bus_volume(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, linear_to_db(linear))

func save_volumes() -> void:
	config.set_value("audio", "master", AudioServer.get_bus_volume_db(AudioServer.get_bus_index(BUS_MASTER)))
	config.set_value("audio", "sfx",    AudioServer.get_bus_volume_db(AudioServer.get_bus_index(BUS_SFX)))
	config.set_value("audio", "music",  AudioServer.get_bus_volume_db(AudioServer.get_bus_index(BUS_MUSIC)))
	config.set_value("audio", "drill",  AudioServer.get_bus_volume_db(AudioServer.get_bus_index(BUS_DRILL)))
	config.save(SAVE_PATH)

func load_volumes() -> void:
	if config.load(SAVE_PATH) != OK:
		master_volume_slider.value = 1.0
		sfx_volume_slider.value    = 1.0
		music_volume_slider.value  = 1.0
		drill_volume_slider.value  = 1.0
	else:
		master_volume_slider.value = db_to_linear(config.get_value("audio", "master", 0.0))
		sfx_volume_slider.value    = db_to_linear(config.get_value("audio", "sfx", 0.0))
		music_volume_slider.value  = db_to_linear(config.get_value("audio", "music", 0.0))
		drill_volume_slider.value  = db_to_linear(config.get_value("audio", "drill", 0.0))
	
	_on_master_volume_slider_value_changed(master_volume_slider.value)
	_on_sfx_volume_slider_value_changed(sfx_volume_slider.value)
	_on_music_volume_slider_value_changed(music_volume_slider.value)
	_on_drill_volume_slider_value_changed(drill_volume_slider.value)

func _on_close_menu_button_pressed() -> void:
	save_volumes()
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_close_menu_button_pressed()
