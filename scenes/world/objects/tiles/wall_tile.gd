@tool
class_name WallTile
extends StaticBody3D

@export var collision_shape: CollisionShape3D
@export var sprite_top: Sprite3D
@export var sprite_bottom: Sprite3D

var tile_set: LevelTileSet
var atlas_coords: Vector2i

func setup_tile() -> void:
	if not tile_set: return
	# Collision Shape
	var shape := BoxShape3D.new()
	var height: float = Globals.TILE_SIZE_METERS * tile_set.wall_height
	shape.size = Vector3(Globals.TILE_SIZE_METERS, height, Globals.TILE_SIZE_METERS)
	collision_shape.shape = shape
	collision_shape.position.y = height / 2.0
	# Top Sprite
	sprite_top.texture = tile_set.wall_texture
	sprite_top.region_rect.size = Vector2(Globals.TILE_SIZE_PIXELS, Globals.TILE_SIZE_PIXELS)
	sprite_top.position.y = height
	# Bottom Sprite
	sprite_bottom.texture = tile_set.wall_texture
	sprite_bottom.region_rect.size = Vector2(Globals.TILE_SIZE_PIXELS, Globals.TILE_SIZE_PIXELS * tile_set.wall_height)
	sprite_bottom.position.y = height / 2.0
	# Texture coords
	update_texture_coords()

func update_texture_coords() -> void:
	if not tile_set: return
	# Top Sprite
	sprite_top.region_rect.position.x = atlas_coords.x * Globals.TILE_SIZE_PIXELS
	sprite_top.region_rect.position.y = atlas_coords.y * (tile_set.wall_height + 1) * Globals.TILE_SIZE_PIXELS
	# Bottom Sprite
	sprite_bottom.region_rect.position.x = atlas_coords.x * Globals.TILE_SIZE_PIXELS
	sprite_bottom.region_rect.position.y = ((atlas_coords.y * (tile_set.wall_height + 1)) + 1) * Globals.TILE_SIZE_PIXELS

func _ready() -> void:
	if Engine.is_editor_hint(): return
	setup_tile()
