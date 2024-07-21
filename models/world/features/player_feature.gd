class_name PlayerFeature
extends Feature

@export var player_scene: PackedScene
@export var camera_scene: PackedScene

func apply(context: LevelContext) -> void:
	var player: CharacterBody3D = player_scene.instantiate()
	player.position = context.get_random_unoccupied_pos()
	context.level_grid.add_child(player)
	var camera: PlayerCamera = camera_scene.instantiate()
	camera.target = player
	context.level_grid.add_child(camera)
