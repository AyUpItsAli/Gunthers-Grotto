@tool
class_name CaveGenerator
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
		if new_value == null: clear_cave()
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
@export_group("Terrains")
@export var ground_terrain: int:
	set(new_value):
		ground_terrain = new_value
		redraw()
@export var wall_terrain: int:
	set(new_value):
		wall_terrain = new_value
		redraw()
@export_group("Cave")
@export_range(0, 200) var min_size: int = 100:
	set(new_value):
		min_size = new_value
		if min_size > max_size:
			min_size = max_size
		redraw()
@export_range(0, 200) var max_size: int = 150:
	set(new_value):
		max_size = new_value
		if max_size < min_size:
			max_size = min_size
		redraw()
@export var level_seed: String = "gunther":
	set(new_value):
		level_seed = new_value
		redraw()
@export_group("Noise", "noise_")
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX:
	set(new_value):
		noise_type = new_value
		redraw()
@export var noise_fractal_type: FastNoiseLite.FractalType = FastNoiseLite.FRACTAL_FBM:
	set(new_value):
		noise_fractal_type = new_value
		redraw()
@export var noise_frequency: float = 0.07:
	set(new_value):
		noise_frequency = new_value
		redraw()
@export var noise_octaves: int = 10:
	set(new_value):
		noise_octaves = new_value
		redraw()
@export var noise_gain: float = 0.5:
	set(new_value):
		noise_gain = new_value
		redraw()
@export var noise_lacunarity: float = 1.6:
	set(new_value):
		noise_lacunarity = new_value
		redraw()
@export var noise_ping_pong_strength: float = 1:
	set(new_value):
		noise_ping_pong_strength = new_value
		redraw()
@export_range(0, 1) var noise_threshold: float = 0.75:
	set(new_value):
		noise_threshold = new_value
		redraw()
@export_range(0, 50) var noise_edge_width: int = 10:
	set(new_value):
		noise_edge_width = new_value
		redraw()

var rng: RandomNumberGenerator
var noise: FastNoiseLite

var cave_width: int
var cave_height: int
var start_x: int
var end_x: int
var start_y: int
var end_y: int

var player_spawn_pos: Vector2
var exit_spawn_pos: Vector2

signal cave_generated

func redraw():
	if Engine.is_editor_hint():
		generate()

const CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

func randomise_seed():
	var new_seed = ""
	for i in range(9):
		new_seed += CHARS[randi() % CHARS.length()]
	level_seed = new_seed

func generate():
	if tile_map == null: return
	clear_cave()
	if tile_map.tile_set == null: return
	
	print("Generating level with seed: " + level_seed)
	
	# General Setup
	rng = RandomNumberGenerator.new()
	rng.seed = level_seed.hash()
	cave_width = rng.randi_range(min_size, max_size)
	cave_height = rng.randi_range(min_size, max_size)
	end_x = int(cave_width / 2.0)
	start_x = -end_x
	end_y = int(cave_height / 2.0)
	start_y = -end_y
	
	# Noise Setup
	noise = FastNoiseLite.new()
	noise.seed = level_seed.hash()
	noise.noise_type = noise_type
	noise.fractal_type = noise_fractal_type
	noise.frequency = noise_frequency
	noise.fractal_octaves = noise_octaves
	noise.fractal_gain = noise_gain
	noise.fractal_lacunarity = noise_lacunarity
	noise.fractal_ping_pong_strength = noise_ping_pong_strength
	
	# Generate
	generate_wall_layer()
	generate_ground_layer()
	
	player_spawn_pos = get_random_unoccupied_pos()
	exit_spawn_pos = get_random_unoccupied_pos()
	
	if not Engine.is_editor_hint():
		cave_generated.emit()

func clear_cave():
	for child in tile_map.get_children():
		tile_map.remove_child(child)
		child.queue_free()
	tile_map.clear_layer(ground_layer)
	tile_map.clear_layer(wall_layer)

func generate_ground_layer():
	var tiles: Array[Vector2i] = []
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_pos = Vector2i(x, y)
			if is_tile_empty(tile_pos):
				tiles.append(tile_pos)
	
	tile_map.set_cells_terrain_connect(ground_layer, tiles, ground_terrain_set, ground_terrain)

func generate_wall_layer():
	# Wall Tiles
	var tiles: Array[Vector2i] = []
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var value = (noise.get_noise_2d(x, y) + 1) / 2.0
			var edge_begin_x = end_x - noise_edge_width
			var edge_begin_y = end_y - noise_edge_width
			
			if abs(x) > edge_begin_x and abs(y) > edge_begin_y: # Corners
				value += (abs(x) - edge_begin_x) / float(noise_edge_width)
				value += (abs(y) - edge_begin_y) / float(noise_edge_width)
			elif abs(x) > edge_begin_x: # Left and Right edges
				value += (abs(x) - edge_begin_x) / float(noise_edge_width)
			elif abs(y) > edge_begin_y: # Top and bottom edges
				value += (abs(y) - edge_begin_y) / float(noise_edge_width)
			
			value = sqrt(value)
			
			if value >= noise_threshold:
				tiles.append(Vector2i(x, y))
	
	tile_map.set_cells_terrain_connect(wall_layer, tiles, wall_terrain_set, wall_terrain)

func is_tile_empty(tile_pos: Vector2i) -> bool:
	return tile_map.get_cell_source_id(wall_layer, tile_pos) == -1

func get_random_tile() -> Vector2i:
	return Vector2i(rng.randi_range(start_x, end_x), rng.randi_range(start_y, end_y))

func get_random_empty_tile() -> Vector2i:
	var tile = get_random_tile()
	while not is_tile_empty(tile):
		tile = get_random_tile()
	return tile

func get_random_unoccupied_pos() -> Vector2:
	var empty_tile = get_random_empty_tile()
	return tile_map.map_to_local(empty_tile)
