@tool
extends StaticBody3D

@export var tile_set: LevelTileSet:
	set(new_value):
		if tile_set == new_value: return
		if tile_set: tile_set.changed.disconnect(update_tile)
		tile_set = new_value
		if tile_set: tile_set.changed.connect(update_tile)
		update_tile()
@export var tile_coords: Vector2i = Vector2i(0, 3):
	set(new_value):
		tile_coords = new_value
		update_tile()
@export var collision_shape: CollisionShape3D
@export var sprite_top: Sprite3D
@export var sprite_bottom: Sprite3D

func update_tile():
	if not collision_shape: return
	var shape = collision_shape.shape as BoxShape3D
	shape.size.y = 1
	collision_shape.position.y = 0.5
	if not sprite_top: return
	sprite_top.texture = null
	if not sprite_bottom: return
	sprite_bottom.texture = null
	if not tile_set: return
	
	# Collision Shape
	shape.size.y = tile_set.wall_height
	collision_shape.position.y = tile_set.wall_height * 0.5
	
	# Top Sprite
	sprite_top.texture = tile_set.texture
	sprite_top.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	sprite_top.region_rect.position.x = tile_coords.x * Globals.TILE_SIZE
	sprite_top.region_rect.position.y = tile_coords.y * (tile_set.wall_height + 1) * Globals.TILE_SIZE
	sprite_top.position.y = tile_set.wall_height
	
	# Bottom Sprite
	sprite_bottom.texture = tile_set.texture
	sprite_bottom.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE * tile_set.wall_height)
	sprite_bottom.region_rect.position.x = tile_coords.x * Globals.TILE_SIZE
	sprite_bottom.region_rect.position.y = ((tile_coords.y * (tile_set.wall_height + 1)) + 1) * Globals.TILE_SIZE
	sprite_bottom.position.y = tile_set.wall_height * 0.5

func _ready():
	update_tile()
