class_name Feature
extends Resource

@export_category("Feature")
@export var id: String
@export var phase: Data.Features.Phase = Data.Features.Phase.ENVIRONMENT
# An array of feature ids
# This feature will only be applied AFTER all prerequisite features have been applied
@export var prerequisites: Array[String]
# If true, this feature will be added to EVERY level,
# regardless of whether this feature is present in the biome's features array or not
@export var global: bool = false

# Applies the feature to the world using the given level context
# Eg: Spawning an enemy or placing an object or landmark
func apply(_context: LevelContext) -> void:
	# New features must extend the base Feature class,
	# then override the apply() function with the feature's unique logic
	pass
