extends Node3D
class_name HoldableComponent

@export_category("Holding")
@export var holding_offset := Vector3.ZERO
@export var holding_rotation_offset := Vector3.ZERO
@export var follow_speed := 12.0

@onready var interactable_area: InteractableArea = $InteractableArea
@onready var collider: CollisionShape3D = %CollisionShape3D
@onready var parent : HoldableItem = self.get_parent()

var held := false
var held_in := InteractionController.InteractedProperties.Neither

var target_position : Vector3
var target_rotation : Vector3

func _ready() -> void:
	interactable_area.interacted.connect(_on_interactable_area_interacted)

func _on_interactable_area_interacted(properties: InteractionController.InteractedProperties) -> void:
	if held:
		if properties == InteractionController.InteractedProperties.RightHand:
			PlayerManager.player.hands_component.drop_right_hand()
		elif properties == InteractionController.InteractedProperties.LeftHand:
			PlayerManager.player.hands_component.drop_left_hand()
	else:
		if properties == InteractionController.InteractedProperties.RightHand:
			PlayerManager.player.hands_component.place_in_right_hand(parent)
		elif properties == InteractionController.InteractedProperties.LeftHand:
			PlayerManager.player.hands_component.place_in_left_hand(parent)

func pick_up() -> void:
	collider.disabled = true
	held = true

func put_down() -> void:
	collider.disabled = false
	held = false

func _process(delta: float) -> void:
	if !held:
		return
	
	update_target()
	
	var target_transform := Transform3D(
		Basis.from_euler(target_rotation),
		target_position
	)
	
	var weight = min(follow_speed * delta, 1.0)
	
	parent.global_transform = parent.global_transform.interpolate_with(
		target_transform,
		weight
	)

func update_target():
	if held_in == InteractionController.InteractedProperties.LeftHand:
		target_position = PlayerManager.player.armature.left_hand_marker.global_position + holding_offset
	else:
		target_position = PlayerManager.player.armature.right_hand_marker.global_position + holding_offset
	
	target_rotation = PlayerManager.player.model.rotation + holding_rotation_offset
