@tool
extends Area3D
class_name InteractableArea

#region Exports
const PREVIEW_NAME := "__HintPreview"

@export var can_interact := true:
	set(value):
		can_interact = value
		_update_preview()

@export var can_hold := false:
	set(value):
		can_hold = value
		_update_preview()

@export_category("Hints")

@export var interactable_name := "Default Name":
	set(value):
		interactable_name = value
		_update_preview()
		
@export var hint_offset := Vector3.ZERO:
	set(value):
		hint_offset = value
		_update_preview()

@export var hint_size := 50:
	set(value):
		hint_size = value
		_update_preview()

@export_range(0, 1)
var hint_distance := 1.0:
	set(value):
		hint_distance = value
		_update_preview()
#endregion

signal interacted(properties: InteractionController.InteractedProperties)

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_preview()
	else:
		_remove_preview()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	set_collision_layer_value(6, true)
	set_collision_layer_value(1, false)

func _on_body_entered(_body: Node3D) -> void:
	PlayerManager.player.interaction_controller.interactable_area_entered(self)

func _on_body_exited(_body: Node3D) -> void:
	PlayerManager.player.interaction_controller.interactable_area_exited(self)

func interact(properties: InteractionController.InteractedProperties) -> void:
	interacted.emit(properties)

#region Editor Preview
func _update_preview():
	if !Engine.is_editor_hint():
		return

	var label := get_node_or_null(PREVIEW_NAME) as Label3D

	if label == null:
		label = Label3D.new()
		label.name = PREVIEW_NAME
		label.owner = null   # prevents saving into the scene
		add_child(label, false, Node.INTERNAL_MODE_FRONT)

	label.text = interactable_name + "\n" + "[Interaction]"
	label.position = hint_offset
	label.font_size = hint_size
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = true

func _remove_preview():
	var label := get_node_or_null(PREVIEW_NAME)
	if label:
		label.queue_free()
#endregion
