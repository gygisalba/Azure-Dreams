extends Node
class_name InteractableHintComponent

@onready var player_state_component: PlayerStateComponent = %PlayerStateComponent
@onready var interaction_controller := %InteractionController

@export var hint_node_default_name := "HINT_TEXT"
@export var hint_offset := Vector3(0, 0, 0) # todo: get offset and size from interactable 
@export_range(1, 200) var hint_size : int = 50
	
func _process(_delta: float) -> void:
	for interactable in interaction_controller.interactables_nearby:
		var hint = interaction_controller.interactables_nearby[interactable]
		if player_state_component.is_player_state(PlayerStateComponent.PlayerState.BUSY):
			hint.hide()
			return
		
		hint.show()
		hint.global_position = ((interactable.global_position + PlayerManager.player.global_position) / 2) + hint_offset

func assign_hint_text(interactable: InteractableArea) -> Label3D:
	var new_hint = create_hint_text(interactable)
	interactable.add_child(new_hint)
	new_hint.global_position = ((interactable.global_position + PlayerManager.player.global_position) / 2) + hint_offset
	return new_hint
	
func deassign_hint_text(interactable: InteractableArea) -> void:
	var hint = interactable.get_node("HINT_TEXT") as Label3D
	hint.queue_free()

func create_hint_text(interactable: InteractableArea) -> Label3D:
	var new_label = Label3D.new()
	new_label.name = "HINT_TEXT"
	new_label.text = get_interaction_key(interactable)
	new_label.billboard = true
	new_label.no_depth_test = true
	new_label.font_size = hint_size
	return new_label

func emphasis_changed(previous_index: int, current_index: int) -> void:
	if previous_index != -1:
		var previous = interaction_controller.interactables_nearby.keys()[previous_index]
		deemphasize_hint_text(previous)
		
	var current = interaction_controller.interactables_nearby.keys()[current_index]
	emphasize_hint_text(current)

func emphasize_hint_text(interactable: InteractableArea) -> void:
	var hint = interactable.get_node("HINT_TEXT") as Label3D
	hint.outline_modulate = Color.CORNFLOWER_BLUE
	hint.outline_size = 6

func deemphasize_hint_text(interactable: InteractableArea) -> void:
	var hint = interactable.get_node("HINT_TEXT") as Label3D
	hint.outline_modulate = Color.BLACK

func get_interaction_key(interactable: InteractableArea) -> String:
	var key_label = ""
	
	if interactable.can_hold:
		var left_str := _event_to_display_string(InputMap.action_get_events("left_hand"))
		var right_str := _event_to_display_string(InputMap.action_get_events("right_hand"))
		key_label = left_str + "/" + right_str
	
	if interactable.can_interact:
		var interact_str := _event_to_display_string(InputMap.action_get_events("interact"))
		if interact_str != "":
			key_label += "\n" + interact_str
	
	return key_label

func _event_to_display_string(events: Array) -> String:
	if events.is_empty():
		return ""
	
	var event: InputEvent = events[0]
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				return "LMB"
			MOUSE_BUTTON_RIGHT:
				return "RMB"
			MOUSE_BUTTON_MIDDLE:
				return "MMB"
			_:
				return event.as_text()   # fallback for extra buttons
	
	if event is InputEventKey:
		return event.as_text_physical_keycode()
	
	# Gamepad buttons, joystick motions, etc.
	return event.as_text()
