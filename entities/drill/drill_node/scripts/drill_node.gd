extends Area3D
class_name DrillNode

@export var max_minerals := 50
@export var current_minerals := 50
@export var minerals_depleted_per_tick := 1

var is_depleted : bool

func connect_to_drill(drill: AzureDrill) -> void:
	if drill.drill_ticked.is_connected(_on_drill_ticked):
		return
	
	drill.drill_ticked.connect(_on_drill_ticked)
	

func _on_drill_ticked() -> void:
	current_minerals -= clampi(current_minerals - minerals_depleted_per_tick, 0, max_minerals)
	
