class_name LevelGrid
extends Node3D

@export var tile_map: TileMap
@export var wall_container: Node3D
@export var ground_container: Node3D
@export var wall_tile_scene: PackedScene
@export var ground_tile_scene: PackedScene

var tile_set: LevelTileSet
var wall_tiles: Dictionary
var ground_tiles: Dictionary

func clear_grid():
	for child in wall_container.get_children():
		wall_container.remove_child(child)
		child.queue_free()
	for child in ground_container.get_children():
		ground_container.remove_child(child)
		child.queue_free()

func place_wall_tile(grid_pos: Vector2i):
	var wall_tile = wall_tile_scene.instantiate()
	if wall_tile is WallTile:
		wall_tile.tile_set = tile_set
		wall_tile.atlas_coords = tile_map.get_cell_atlas_coords(0, grid_pos)
		wall_tile.position = Vector3(grid_pos.x, 0, grid_pos.y)
		wall_container.add_child(wall_tile)
		wall_tiles[grid_pos] = wall_tile

# Note: If done during gameplay, call in deferred mode to avoid potential lag spike
func remove_wall_tile(grid_pos: Vector2i):
	if not grid_pos in wall_tiles: return
	
	# Place new ground tile in this new empty space
	place_ground_tile(grid_pos)
	
	# Remove wall tile
	var wall_tile = wall_tiles[grid_pos] as WallTile
	wall_container.remove_child(wall_tile)
	wall_tile.queue_free()
	wall_tiles.erase(grid_pos)
	
	# Erase the tile in the tile map (this method handles updating neighbours)
	tile_map.set_cells_terrain_connect(0, [grid_pos], 0, -1)
	
	# Update neighbours
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			if i == 0 and j == 0: continue
			var neighbour_pos = grid_pos + Vector2i(i, j)
			if not neighbour_pos in wall_tiles: continue
			var neighbour_tile = wall_tiles[neighbour_pos] as WallTile
			neighbour_tile.atlas_coords = tile_map.get_cell_atlas_coords(0, neighbour_pos)
			neighbour_tile.update_texture_coords()

func place_ground_tile(grid_pos: Vector2i):
	var ground_tile = ground_tile_scene.instantiate()
	if ground_tile is GroundTile:
		ground_tile.tile_set = tile_set
		ground_tile.texture_index = tile_set.get_random_ground_texture_index()
		ground_tile.position = Vector3(grid_pos.x, 0, grid_pos.y)
		ground_container.add_child(ground_tile)
		ground_tiles[grid_pos] = ground_tile

func _unhandled_input(event):
	if event.is_action_pressed("test"):
		remove_wall_tile.call_deferred(Vector2i(0, -1))
		remove_wall_tile.call_deferred(Vector2i(0, -2))
		remove_wall_tile.call_deferred(Vector2i(0, -3))
		remove_wall_tile.call_deferred(Vector2i(0, -4))
		remove_wall_tile.call_deferred(Vector2i(0, -5))
