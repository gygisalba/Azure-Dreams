extends Control
class_name BaseMenu

@export_category("Animation")
@export var tween_duration := 1.5
@export var tween_speed := 1.0
@export var start_pos_offset := Vector2(0, -1000)
@export var ease_type : Tween.EaseType = Tween.EASE_OUT
@export var trans_type : Tween.TransitionType = Tween.TRANS_SPRING
var tween : Tween

func _ready() -> void:
	start_tween()

func start_tween() -> void:
	if tween:
		tween.kill()
	
	var new_start_pos = position + start_pos_offset
	var target_end_pos = position
	
	set_position(new_start_pos)
	
	tween = create_tween()
	tween.set_speed_scale(tween_speed)
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(self, "position", target_end_pos, tween_duration)
