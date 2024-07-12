@tool
class_name GroundTile
extends Node3D

@export var sprite: Sprite3D

var tile_set: LevelTileSet
var atlas_coords: Vector2i

func setup_tile():
	if not tile_set: return
	sprite.texture = tile_set.ground_texture
	sprite.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	sprite.region_rect.position = Vector2(atlas_coords * Globals.TILE_SIZE)

func _ready():
	if Engine.is_editor_hint(): return
	setup_tile()
