class_name LevelContext
extends Object

# Tile map and Level grid
var tile_map: TileMap
var level_grid: LevelGrid

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
	level_grid = level_generator.level_grid
	width = level_generator.width
	height = level_generator.height
	start_x = level_generator.start_x
	end_x = level_generator.end_x
	start_y = level_generator.start_y
	end_y = level_generator.end_y
	biome = level_generator.biome
	rng = level_generator.rng

func is_tile_empty(grid_pos: Vector2i) -> bool:
	return tile_map.get_cell_source_id(0, grid_pos) == -1

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
