@tool
class_name LevelTileSet
extends Resource

@export var wall_texture: Texture2D:
	set(new_value):
		wall_texture = new_value
		emit_changed()
@export_range(1, 5) var wall_height: int = 1:
	set(new_value):
		wall_height = new_value
		emit_changed()
@export var ground_texture: Texture2D:
	set(new_value):
		ground_texture = new_value
		emit_changed()
@export var ground_probabilities: Array[float]

func get_random_ground_texture_index() -> int:
	var value = randf()
	var prob = 0
	for i in range(ground_probabilities.size()):
		prob += ground_probabilities[i]
		if value < prob:
			return i
	return 0
