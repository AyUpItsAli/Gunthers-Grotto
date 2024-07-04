class_name EnemyCluster
extends Feature

@export var enemy_scene: PackedScene
@export_color_no_alpha var color: Color

func apply(context: LevelContext):
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	enemy.position = context.get_random_unoccupied_pos()
	var sprite: Sprite2D = enemy.get_node("Sprite2D")
	sprite.modulate = color
	context.tile_map.add_child(enemy)
