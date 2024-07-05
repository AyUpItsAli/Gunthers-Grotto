class_name LevelContext
extends Object

# Tile map
var tile_map: TileMap
var ground_layer: int
var wall_layer: int

# Dimensions
var width: int
var height: int
var start_x: int
var end_x: int
var start_y: int
var end_y: int

# Other
var biome: Biome
var rng: RandomNumberGenerator

func _init(level_generator: LevelGenerator):
	tile_map = level_generator.tile_map
	ground_layer = level_generator.ground_layer
	wall_layer = level_generator.wall_layer
	width = level_generator.width
	height = level_generator.height
	start_x = level_generator.start_x
	end_x = level_generator.end_x
	start_y = level_generator.start_y
	end_y = level_generator.end_y
	biome = level_generator.biome
	rng = level_generator.rng

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
