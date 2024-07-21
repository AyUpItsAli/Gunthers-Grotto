extends Node

const FEATURES: ResourceGroup = preload("res://data/world/features.tres")
const BIOMES: ResourceGroup = preload("res://data/world/biomes.tres")

func _ready() -> void:
	Features.load_features()
	Biomes.load_biomes()

class Features:
	static var _features: Dictionary
	static var _global_features: Array[Feature]
	
	enum Phase {
		ENVIRONMENT, # Terrain manipulations and additions
		LANDMARK, # Structures, Important objects
		DECORATION, # Scattered objects / filling in gaps
		ACTORS # Enemies, NPC, Player
	}
	
	static func load_features() -> void:
		for path in FEATURES.paths:
			var feature: Feature = load(path)
			_features[feature.id] = feature
			if feature.global:
				_global_features.append(feature)
	
	static func get_feature(id: String) -> Feature:
		return _features.get(id)
	
	static func construct_phases(features: Array[Feature]) -> Dictionary:
		# Setup empty phases
		var phases := {}
		for phase: int in Phase.values():
			phases[phase] = []
		# Include global features in phase construction
		features.append_array(_global_features)
		# Add each feature to phases
		for feature in features:
			# Don't add if already added
			if feature in phases[feature.phase]:
				continue
			add_feature(feature, phases, [])
		return phases
	
	static func add_feature(feature: Feature, phases: Dictionary, stack: Array[Feature]) -> void:
		# Add this feature to the stack
		stack.append(feature)
		# Ensure prerequisite features are added FIRST
		for id in feature.prerequisites:
			var pre_feature: Feature = get_feature(id)
			# Don't add if currently in the stack (prevent infinite loops)
			if pre_feature in stack:
				continue
			# Don't add if already added
			if pre_feature in phases[pre_feature.phase]:
				continue
			add_feature(pre_feature, phases, stack)
		# Add this feature AFTER prerequisites have been added
		phases[feature.phase].append(feature)
		# Remove this feature from the stack.
		stack.pop_back()

class Biomes:
	static var _biomes: Dictionary
	
	enum Id {
		PROTOTYPE
	}
	
	static func load_biomes() -> void:
		for path in BIOMES.paths:
			var biome: Biome = load(path)
			_biomes[biome.id] = biome
