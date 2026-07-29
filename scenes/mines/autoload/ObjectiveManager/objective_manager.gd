extends Node

signal objective_created(objective)
const objectives_folder := "res://scenes/mines/shift_objectives/"

var objectives_complete := false
signal all_objectives_completed

var current_objectives : Array[Objective]

func _ready() -> void:
	NightManager.night_started.connect(_on_night_started)
	NightManager.night_ended.connect(_on_night_ended)

func _on_night_started() -> void:
	load_objectives(1) # Later, check the save data to see what night we are on.

func _on_night_ended() -> void:
	current_objectives.clear()

func load_objectives(shift: int) -> void:
	var target_path = objectives_folder + str(shift)
	var files = DirAccess.get_files_at(target_path)
	for file in files:
		var full_path = target_path + '/' + file
		if ResourceLoader.exists(full_path):
			var objective = load(full_path) as Objective
			if objective:
				create_objective(objective)
			else:
				push_warning("Skipping non-Objective file: " + full_path)
		

func create_objective(objective: Objective) -> void:
	objective.objective_condition.setup_objective()
	objective_created.emit(objective)
	if not objective.objective_condition.objective_fulfilled.is_connected(_on_objective_fulfilled):
		objective.objective_condition.objective_fulfilled.connect(_on_objective_fulfilled.bind(objective))
	current_objectives.append(objective)

func _on_objective_fulfilled(objective: Objective) -> void:
	objective.objective_fulfilled = true
	if check_objectives_complete():
		objectives_complete = true
		all_objectives_completed.emit()

func check_objectives_complete() -> bool:
	for objective in current_objectives:
		if !objective.objective_fulfilled:
			return false
		
	return true
