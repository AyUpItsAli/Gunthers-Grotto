@tool
class_name LevelGenerator
extends Node

@export_group("Nodes")
@export var tile_map: TileMap
@export var level_grid: LevelGrid
@export_group("Settings")
@export_range(0, 200) var min_size: int = 50:
	set(new_value):
		if new_value > max_size:
			min_size = max_size
		else:
			min_size = new_value
		settings_changed.emit()
@export_range(0, 200) var max_size: int = 100:
	set(new_value):
		if new_value < min_size:
			max_size = min_size
		else:
			max_size = new_value
		settings_changed.emit()
@export var level_seed: String = "gunther":
	set(new_value):
		level_seed = new_value
		settings_changed.emit()
@export var biome: Biome:
	set(new_value):
		if biome == new_value: return
		if biome: biome.changed.disconnect(_on_biome_changed)
		biome = new_value
		if biome: biome.changed.connect(_on_biome_changed)
		settings_changed.emit()

var width: int
var height: int
var start_x: int
var end_x: int
var start_y: int
var end_y: int

var rng: RandomNumberGenerator
var noise: FastNoiseLite
var context: LevelContext

signal settings_changed
signal level_generated

func _on_biome_changed() -> void:
	settings_changed.emit()

func setup_generator() -> void:
	print("Setting up level generator...")
	
	# RNG Setup
	rng = RandomNumberGenerator.new()
	rng.seed = level_seed.hash()
	
	# Dimensions Setup
	width = rng.randi_range(min_size, max_size)
	height = rng.randi_range(min_size, max_size)
	end_x = int(width / 2.0)
	start_x = -end_x
	end_y = int(height / 2.0)
	start_y = -end_y
	print("Level size is: %sx%s" % [width, height])
	
	# Noise Setup
	noise = FastNoiseLite.new()
	noise.seed = level_seed.hash()
	noise.noise_type = biome.noise_type
	noise.fractal_type = biome.noise_fractal_type
	noise.frequency = biome.noise_frequency
	noise.fractal_octaves = biome.noise_octaves
	noise.fractal_gain = biome.noise_gain
	noise.fractal_lacunarity = biome.noise_lacunarity
	noise.fractal_ping_pong_strength = biome.noise_ping_pong_strength
	noise.offset = Vector3.ZERO
	
	# Context Setup
	context = LevelContext.new(self)

func generate_tiles() -> void:
	print("Generating tile map tiles...")
	var tiles: Array[Vector2i] = []
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var value: float = (noise.get_noise_2d(x, y) + 1) / 2.0
			var edge_begin_x: int = end_x - biome.noise_edge_width
			var edge_begin_y: int = end_y - biome.noise_edge_width
			
			if abs(x) > edge_begin_x and abs(y) > edge_begin_y: # Corners
				value += (abs(x) - edge_begin_x) / float(biome.noise_edge_width)
				value += (abs(y) - edge_begin_y) / float(biome.noise_edge_width)
			elif abs(x) > edge_begin_x: # Left and Right edges
				value += (abs(x) - edge_begin_x) / float(biome.noise_edge_width)
			elif abs(y) > edge_begin_y: # Top and bottom edges
				value += (abs(y) - edge_begin_y) / float(biome.noise_edge_width)
			
			value = sqrt(value)
			
			if value >= biome.noise_threshold:
				tiles.append(Vector2i(x, y))
	
	tile_map.set_cells_terrain_connect(0, tiles, 0, 0)

func clear_level() -> void:
	print("Clearing level...")
	level_grid.clear_grid()

func generate_terrain() -> void:
	print("Generating terrain...")
	level_grid.tile_set = biome.tile_set
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var grid_pos := Vector2i(x, y)
			if context.is_tile_empty(grid_pos):
				level_grid.place_ground_tile(grid_pos)
			else:
				level_grid.place_wall_tile(grid_pos)
	level_grid.bake_navigation()

func apply_features() -> void:
	print("Applying features...")
	var phases: Dictionary = Data.Features.construct_phases(biome.features)
	for phase: int in phases:
		var features: Array = phases[phase]
		print("%s Phase (%s)" % [Data.Features.Phase.find_key(phase), features.size()])
		if features.is_empty():
			print("- None")
			continue
		for feature: Feature in features:
			print("- Applying feature: %s" % feature.id)
			feature.apply(context)

func generate() -> void:
	if not tile_map: return
	tile_map.clear()
	if not biome: return
	
	# Setup
	setup_generator()
	# Generate tile map tiles
	generate_tiles()
	
	if Engine.is_editor_hint(): return
	if not level_grid: return
	
	# Clear level
	clear_level()
	# Generate terrain
	generate_terrain()
	# Apply features
	apply_features()
	# Notify listeners
	level_generated.emit()

func randomise_seed() -> void:
	var new_seed: String = ""
	for i in range(9):
		new_seed += Globals.SEED_CHARS[randi() % Globals.SEED_CHARS.length()]
	level_seed = new_seed
