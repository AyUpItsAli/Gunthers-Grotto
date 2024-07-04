extends Node

const FEATURES: ResourceGroup = preload("res://data/features.tres")

func _ready():
	World.load_features()

class World:
	static var features: Dictionary
	static var ordered_features: Array[Feature]
	
	# Stages
	# - Environment
	# - Objects
	# - Actors
	
	static func load_features():
		for path in FEATURES.paths:
			var feature: Feature = load(path)
			features[feature.id] = feature
		for feature in features.values():
			if feature in ordered_features:
				continue
			order_feature(feature, [])

	static func order_feature(feature: Feature, stack: Array[Feature]):
		stack.append(feature)
		for id in feature.dependencies:
			var dependency: Feature = features[id]
			if dependency in stack:
				continue
			if dependency in ordered_features:
				continue
			order_feature(dependency, stack)
		ordered_features.append(feature)
		stack.pop_back()
	
	static func get_ordered_features() -> Array[Feature]:
		return ordered_features
