extends ObjectiveCondition
class_name CollectAzureCondition

func setup_objective() -> void:
	if not AzureManager.azure_filled.is_connected(_on_azure_filled):
		AzureManager.azure_filled.connect(_on_azure_filled)

func _on_azure_filled() -> void:
	fulfill_objective()
