extends Node

@export var level_generator: LevelGenerator
@export var seed_label: Label

func _ready() -> void:
	level_generator.generate()

func _on_level_generator_level_generated() -> void:
	seed_label.text = "Seed: " + level_generator.level_seed
