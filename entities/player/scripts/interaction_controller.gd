extends Node
class_name InteractionController

@onready var interactable_hint_component := $InteractableHintComponent
@onready var player_state_component := %PlayerStateComponent

enum InteractedProperties {
	LeftHand,
	RightHand,
	Neither,
	Both,
}
	
# Region Entering & Exiting
var selected_interactable_index : int
var interactables_nearby : Dictionary[InteractableArea, Label3D] = {}

func interactable_area_entered(area: InteractableArea) -> void:
	var new_hint = interactable_hint_component.assign_hint_text(area)
	interactables_nearby[area] = new_hint
	if interactables_nearby.size() == 1:
		interactable_hint_component.emphasis_changed(-1, 0)

func interactable_area_exited(area: InteractableArea) -> void:
	interactables_nearby.erase(area)
	interactable_hint_component.deassign_hint_text(area)

## Interacting
func _input(event: InputEvent) -> void:
	if player_state_component.current_state == player_state_component.PlayerState.BUSY:
		return
	
	if interactables_nearby.is_empty():
		return
	
	_handle_interaction(event)
	_handle_scrolling(event)

func _handle_scrolling(event: InputEvent) -> void:
	if event.is_action_pressed("cycle_interactable"):
		var previous = selected_interactable_index
		var next = selected_interactable_index + 1
		if next > interactables_nearby.size() - 1:
			next = 0
		selected_interactable_index = max(0, next)
		interactable_hint_component.emphasis_changed(previous, selected_interactable_index)

func _handle_interaction(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var interactable = interactables_nearby.keys()[selected_interactable_index]
		interactable.interact(InteractedProperties.Neither)
	elif event.is_action_pressed("left_hand"):
		var interactable = interactables_nearby.keys()[selected_interactable_index]
		interactable.interact(InteractedProperties.LeftHand)
	elif event.is_action_pressed("right_hand"):
		var interactable = interactables_nearby.keys()[selected_interactable_index]
		interactable.interact(InteractedProperties.RightHand)
