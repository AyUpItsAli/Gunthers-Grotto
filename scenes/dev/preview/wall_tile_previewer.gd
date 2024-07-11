@tool
extends Node

@export var wall_tile: WallTile
@warning_ignore("unused_private_class_variable")
@export var _redraw: bool = true:
	set(new_value):
		_redraw = true
		redraw()
@export var tile_set: WallTileSet:
	set(new_value):
		if tile_set == new_value: return
		if tile_set: tile_set.changed.disconnect(redraw)
		tile_set = new_value
		if tile_set: tile_set.changed.connect(redraw)
		redraw()
@export var atlas_coords: Vector2i = Vector2i(0, 3):
	set(new_value):
		atlas_coords = new_value
		redraw()

func redraw():
	if not wall_tile: return
	(wall_tile.collision_shape.shape as BoxShape3D).size.y = 1
	wall_tile.collision_shape.position.y = 0.5
	wall_tile.sprite_top.texture = null
	wall_tile.sprite_bottom.texture = null
	if not tile_set: return
	wall_tile.tile_set = tile_set
	wall_tile.atlas_coords = atlas_coords
	wall_tile.setup_tile()
