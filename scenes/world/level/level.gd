extends Node

@export var level_generator: LevelGenerator

func _ready() -> void:
	level_generator.generate()
