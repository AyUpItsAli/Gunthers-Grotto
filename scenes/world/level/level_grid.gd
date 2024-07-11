class_name LevelGrid
extends Node3D

@export var wall_tile_scene: PackedScene

var tile_set: WallTileSet
var tiles: Dictionary

func place_wall_tile(grid_pos: Vector2i, atlas_coords: Vector2i):
	var wall_tile = wall_tile_scene.instantiate()
	if wall_tile is WallTile:
		wall_tile.tile_set = tile_set
		wall_tile.atlas_coords = atlas_coords
		wall_tile.position = Vector3(grid_pos.x, 0, grid_pos.y)
		add_child(wall_tile)
		tiles[grid_pos] = wall_tile
