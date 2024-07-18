class_name Feature
extends Resource

@export_category("Feature")
@export var id: String
@export var phase: Data.Features.Phase = Data.Features.Phase.ENVIRONMENT
@export var prerequisites: Array[String]

func apply(_context: LevelContext) -> void:
	pass
