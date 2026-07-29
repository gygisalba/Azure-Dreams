extends Node3D

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

@export var up_pos := 100.0
@export var down_pos := -25.0
@export var speed := 5.0
@export var arrival_threshold := 0.1

@export var cutscene_duration := 15.0

var target_y: float

signal lift_arrived

func _ready() -> void:
	descend_lift()
	NightManager.night_ended.connect(_on_night_ended)

func _on_night_ended() -> void:
	ascend_lift()
	await lift_arrived
	LoadingManager.load_scene("res://scenes/hub/hub_area.tscn")

func descend_lift() -> void:
	target_y = down_pos
	_setup_lift_cutscene()
	
func ascend_lift() -> void:
	target_y = up_pos
	_setup_lift_cutscene()
	
func _setup_lift_cutscene() -> void:
	PlayerManager.player.player_state_component.set_player_state(PlayerStateComponent.PlayerState.BUSY)
	phantom_camera_3d.priority = 10
	await get_tree().create_timer(cutscene_duration).timeout
	phantom_camera_3d.priority = 0
	PlayerManager.player.player_state_component.set_player_state(PlayerStateComponent.PlayerState.IDLE)
	lift_arrived.emit()

func _physics_process(delta: float) -> void:
	if abs(global_position.y - target_y) < arrival_threshold:
		global_position.y = target_y
		return
	
	var new_y = move_toward(global_position.y, target_y, speed * delta)
	global_position = Vector3(global_position.x, new_y, global_position.z)
