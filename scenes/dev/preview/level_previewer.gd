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
		randomise_seed()

func randomise_seed():
	if not level_generator: return
	var new_seed = ""
	for i in range(9):
		new_seed += Globals.SEED_CHARS[randi() % Globals.SEED_CHARS.length()]
	level_generator.level_seed = new_seed

func _on_level_generator_settings_changed():
	redraw()

func redraw():
	if not Engine.is_editor_hint(): return
	if not level_generator: return
	level_generator.tile_map.visible = true
	level_generator.generate()
