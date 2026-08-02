extends CharacterBody3D
class_name Player

@onready var camera_controller: CameraController = %CameraController
@onready var movement_controller: MovementController = %MovementController
@onready var menu_input_component: MenuInputComponent = %MenuInputComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var dialogue_component: DialogueComponent = %DialogueComponent
@onready var death_component: DeathComponent = %DeathComponent
@onready var player_state_component: PlayerStateComponent = %PlayerStateComponent
@onready var interaction_controller: InteractionController = %InteractionController
@onready var hands_component: HandsComponent = %HandsComponent
@onready var interactable_hint_controller: InteractableHintController = %InteractableHintController

@onready var user_interface_layer: UserInterface = %UserInterfaceLayer

@onready var collider: CollisionShape3D = $Collider
@onready var armature: PlayerArmature = %Armature
@onready var model: Node3D = $Model


func _ready() -> void:
	PlayerManager.player = self
	death_component.player_died.connect(_on_player_died)

func _on_player_died(death_type: String) -> void:
		DeathManager.enter_death_screen(death_type)
