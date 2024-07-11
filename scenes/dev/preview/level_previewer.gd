@tool
extends Node

@export var level_generator: LevelGenerator
@warning_ignore("unused_private_class_variable")
@export var _redraw: bool = true:
	set(new_value):
		_redraw = true
		redraw()
@warning_ignore("unused_private_class_variable")
@export var _new_seed: bool = true:
	set(new_value):
		_new_seed = true
		redraw(true)

func _on_level_generator_settings_changed():
	redraw()

func redraw(new_seed: bool = false):
	if not level_generator: return
	if new_seed:
		level_generator.randomise_seed()
	else:
		level_generator.generate()
