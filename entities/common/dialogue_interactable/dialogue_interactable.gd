@tool
extends InteractableArea
class_name DialogueInteractable
## An interactable area that shows dialogue when interacted with.

@export var dialogue_resource: DialogueResource ## The dialogue that's actually being read to the player.

func _ready() -> void:
	super()
	interacted.connect(_show_dialogue)

func _show_dialogue(properties: InteractionController.InteractedProperties) -> void:
	if properties == InteractionController.InteractedProperties.Neither:
		DialogueManager.show_dialogue_balloon(dialogue_resource)
