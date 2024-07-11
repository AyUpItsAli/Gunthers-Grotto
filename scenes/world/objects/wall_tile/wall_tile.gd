@tool
class_name WallTile
extends StaticBody3D

@export var collision_shape: CollisionShape3D
@export var sprite_top: Sprite3D
@export var sprite_bottom: Sprite3D

var tile_set: WallTileSet
var atlas_coords: Vector2i

func setup_tile():
	if not tile_set: return
	# Collision Shape
	(collision_shape.shape as BoxShape3D).size.y = tile_set.wall_height
	collision_shape.position.y = tile_set.wall_height * 0.5
	# Top Sprite
	sprite_top.texture = tile_set.texture
	sprite_top.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	sprite_top.position.y = tile_set.wall_height
	# Bottom Sprite
	sprite_bottom.texture = tile_set.texture
	sprite_bottom.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE * tile_set.wall_height)
	sprite_bottom.position.y = tile_set.wall_height * 0.5
	# Texture coords
	update_texture_coords()

func update_texture_coords():
	if not tile_set: return
	# Top Sprite
	sprite_top.region_rect.position.x = atlas_coords.x * Globals.TILE_SIZE
	sprite_top.region_rect.position.y = atlas_coords.y * (tile_set.wall_height + 1) * Globals.TILE_SIZE
	# Bottom Sprite
	sprite_bottom.region_rect.position.x = atlas_coords.x * Globals.TILE_SIZE
	sprite_bottom.region_rect.position.y = ((atlas_coords.y * (tile_set.wall_height + 1)) + 1) * Globals.TILE_SIZE

func _ready():
	if Engine.is_editor_hint(): return
	setup_tile()
