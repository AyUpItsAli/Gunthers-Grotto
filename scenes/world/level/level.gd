extends Node

@export var level_generator: LevelGenerator

func _ready():
	level_generator.generate()
