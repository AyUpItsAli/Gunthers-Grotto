@tool
class_name LevelGenerator
extends Node

@warning_ignore("unused_private_class_variable")
@export var _redraw: bool = true:
	set(new_value):
		redraw()
@warning_ignore("unused_private_class_variable")
@export var _new_seed: bool = true:
	set(new_value):
		randomise_seed()
		if not Engine.is_editor_hint():
			generate()
@export_group("Tile Map")
@export var tile_map: TileMap:
	set(new_value):
		if tile_map == new_value: return
		if new_value == null: clear_level()
		tile_map = new_value
		redraw()
@export var ground_layer: int:
	set(new_value):
		ground_layer = new_value
		redraw()
@export var ground_terrain_set: int:
	set(new_value):
		ground_terrain_set = new_value
		redraw()
@export var wall_layer: int = 1:
	set(new_value):
		wall_layer = new_value
		redraw()
@export var wall_terrain_set: int = 1:
	set(new_value):
		wall_terrain_set = new_value
		redraw()
@export_group("Level")
@export_range(0, 200) var min_size: int = 50:
	set(new_value):
		min_size = new_value
		if min_size > max_size:
			min_size = max_size
		redraw()
@export_range(0, 200) var max_size: int = 100:
	set(new_value):
		max_size = new_value
		if max_size < min_size:
			max_size = min_size
		redraw()
@export var level_seed: String = "gunther":
	set(new_value):
		level_seed = new_value
		redraw()
@export var biome: Biome:
	set(new_value):
		if biome == new_value: return
		if biome: biome.changed.disconnect(redraw)
		biome = new_value
		if biome: biome.changed.connect(redraw)
		redraw()

var width: int
var height: int
var start_x: int
var end_x: int
var start_y: int
var end_y: int

var rng: RandomNumberGenerator
var noise: FastNoiseLite
var context: LevelContext

var player_spawn_pos: Vector2
var exit_spawn_pos: Vector2

signal level_generated

func redraw():
	if Engine.is_editor_hint():
		generate()

const CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

func randomise_seed():
	var new_seed = ""
	for i in range(9):
		new_seed += CHARS[randi() % CHARS.length()]
	level_seed = new_seed

func clear_level():
	for child in tile_map.get_children():
		tile_map.remove_child(child)
		child.queue_free()
	tile_map.clear_layer(ground_layer)
	tile_map.clear_layer(wall_layer)

func setup_generator():
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

func generate_ground_layer():
	var tiles: Array[Vector2i] = []
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_pos = Vector2i(x, y)
			if context.is_tile_empty(tile_pos):
				tiles.append(tile_pos)
	
	tile_map.set_cells_terrain_connect(ground_layer, tiles, ground_terrain_set, biome.ground_terrain)

func generate_wall_layer():
	# Wall Tiles
	var tiles: Array[Vector2i] = []
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var value = (noise.get_noise_2d(x, y) + 1) / 2.0
			var edge_begin_x = end_x - biome.noise_edge_width
			var edge_begin_y = end_y - biome.noise_edge_width
			
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
	
	tile_map.set_cells_terrain_connect(wall_layer, tiles, wall_terrain_set, biome.wall_terrain)

func apply_features():
	var phases: Dictionary = Data.Features.construct_phases(biome.features)
	for phase in phases:
		print("Entering %s phase" % Data.Features.Phase.find_key(phase))
		var features: Array = phases[phase]
		print("Applying features (%s)" % features.size())
		for feature in features:
			if feature is Feature:
				feature.apply(context)

func generate():
	if tile_map == null: return
	clear_level()
	if tile_map.tile_set == null: return
	if biome == null: return
	
	# Setup
	print("Setting up level generator")
	setup_generator()
	
	# Generate Terrain
	print("Generating level with seed: " + level_seed)
	generate_wall_layer()
	generate_ground_layer()
	
	if not Engine.is_editor_hint():
		# Apply Features
		apply_features()
		player_spawn_pos = context.get_random_unoccupied_pos()
		exit_spawn_pos = context.get_random_unoccupied_pos()
		# Notify listeners
		level_generated.emit()
