@tool
extends Node

@export_group("Tiles")
@export var wall_tile: WallTile
@export var ground_tile: GroundTile
@export_group("Settings")
@warning_ignore("unused_private_class_variable")
@export var _redraw: bool = true:
	set(new_value):
		_redraw = true
		redraw()
@export var tile_set: LevelTileSet:
	set(new_value):
		if tile_set == new_value: return
		if tile_set: tile_set.changed.disconnect(redraw)
		tile_set = new_value
		if tile_set: tile_set.changed.connect(redraw)
		redraw()
@export var wall_atlas_coords: Vector2i = Vector2i(0, 3):
	set(new_value):
		wall_atlas_coords = new_value
		redraw()
@export var ground_texture_index: int = 1:
	set(new_value):
		ground_texture_index = new_value
		redraw()

func redraw():
	if wall_tile:
		(wall_tile.collision_shape.shape as BoxShape3D).size.y = 1
		wall_tile.collision_shape.position.y = 0.5
		wall_tile.sprite_top.texture = null
		wall_tile.sprite_bottom.texture = null
	if ground_tile:
		ground_tile.sprite.texture = null
	if not tile_set: return
	if wall_tile:
		wall_tile.tile_set = tile_set
		wall_tile.atlas_coords = wall_atlas_coords
		wall_tile.setup_tile()
	if ground_tile:
		ground_tile.tile_set = tile_set
		ground_tile.texture_index = ground_texture_index
		ground_tile.setup_tile()
