class_name EnemyCluster
extends Feature

@export var enemy_scene: PackedScene

func apply(context: LevelContext) -> void:
	var enemy: CharacterBody3D = enemy_scene.instantiate()
	enemy.position = context.get_random_unoccupied_pos()
	context.level_grid.add_child(enemy)
