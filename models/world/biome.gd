@tool
class_name Biome
extends Resource

@export_category("Biome")
@export var id: Data.Biomes.Id
@export var name: String
@export_group("Noise", "noise_")
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX:
	set(new_value):
		noise_type = new_value
		emit_changed()
@export var noise_fractal_type: FastNoiseLite.FractalType = FastNoiseLite.FRACTAL_FBM:
	set(new_value):
		noise_fractal_type = new_value
		emit_changed()
@export var noise_frequency: float = 0.07:
	set(new_value):
		noise_frequency = new_value
		emit_changed()
@export var noise_octaves: int = 10:
	set(new_value):
		noise_octaves = new_value
		emit_changed()
@export var noise_gain: float = 0.5:
	set(new_value):
		noise_gain = new_value
		emit_changed()
@export var noise_lacunarity: float = 1.6:
	set(new_value):
		noise_lacunarity = new_value
		emit_changed()
@export var noise_ping_pong_strength: float = 1:
	set(new_value):
		noise_ping_pong_strength = new_value
		emit_changed()
@export_range(0, 1) var noise_threshold: float = 0.75:
	set(new_value):
		noise_threshold = new_value
		emit_changed()
@export_range(0, 50) var noise_edge_width: int = 10:
	set(new_value):
		noise_edge_width = new_value
		emit_changed()
@export_group("Level")
@export var tile_set: LevelTileSet
@export var features: Array[Feature]
