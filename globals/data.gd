extends Node

const FEATURES: ResourceGroup = preload("res://data/features.tres")
const BIOMES: ResourceGroup = preload("res://data/biomes.tres")

func _ready():
	Features.load_features()
	Biomes.load_biomes()

class Features:
	static var _features: Dictionary
	
	enum Phase {
		ENVIRONMENT, # Terrain manipulations and additions
		LANDMARK, # Structures, Important objects
		DECORATION, # Scattered objects / filling in gaps
		ACTORS # Enemies, NPC, Player
	}
	
	static func load_features():
		for path in FEATURES.paths:
			var feature: Feature = load(path)
			_features[feature.id] = feature
	
	static func get_feature(id: String) -> Feature:
		return _features.get(id)
	
	static func construct_phases(features: Array[Feature]) -> Dictionary:
		var phases = {}
		for phase in Phase.values():
			phases[phase] = []
		for feature in features:
			if feature in phases[feature.phase]:
				continue
			add_feature(feature, phases, [])
		return phases
	
	static func add_feature(feature: Feature, phases: Dictionary, stack: Array[Feature]):
		stack.append(feature)
		for id in feature.prerequisites:
			var pre_feature: Feature = get_feature(id)
			if pre_feature in stack:
				continue
			if pre_feature in phases[pre_feature.phase]:
				continue
			add_feature(pre_feature, phases, stack)
		phases[feature.phase].append(feature)
		stack.pop_back()

class Biomes:
	static var _biomes: Dictionary
	
	enum Id {
		PROTOTYPE
	}
	
	static func load_biomes():
		for path in BIOMES.paths:
			var biome: Biome = load(path)
			_biomes[biome.id] = biome
