@tool
class_name GroundTile
extends Node3D

@export var sprite: Sprite3D

var tile_set: LevelTileSet
var texture_index: int

func setup_tile() -> void:
	if not tile_set: return
	sprite.texture = tile_set.ground_texture
	sprite.region_rect.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	sprite.region_rect.position = Vector2(texture_index * Globals.TILE_SIZE, 0)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	setup_tile()
