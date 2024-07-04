extends Node2D

@export var cave_generator: CaveGenerator
@export var tile_map: TileMap
@export var debug_canvas: CanvasLayer
@export var seed_label: Label
@export var new_seed_button: Button
@export_category("Level Settings")
@export var level_start_delay: float = 1
@export var level_end_delay: float = 1
@export var single_enemy: bool = true
@export_group("Scenes", "scene_")
@export var scene_player: PackedScene
@export var scene_camera: PackedScene
@export var scene_exit: PackedScene

var player: Gunther
var camera: Camera
var exit: Area2D

func _ready():
	debug_canvas.visible = true
	generate_level()

func generate_level():
	cave_generator.generate()

func _on_new_seed_button_pressed():
	cave_generator.randomise_seed()
	generate_level()
	new_seed_button.release_focus()

func _on_cave_generated():
	seed_label.text = "Seed: " + cave_generator.level_seed
	
	# Player
	player = scene_player.instantiate()
	player.position = cave_generator.player_spawn_pos
	tile_map.add_child(player)

	# Camera
	camera = scene_camera.instantiate()
	camera.target = player
	var tile_size: int = tile_map.tile_set.tile_size.x
	camera.limit_left = -int(cave_generator.cave_width / 2.0) * tile_size
	camera.limit_right = (int(cave_generator.cave_width / 2.0) + 1) * tile_size
	camera.limit_top = -int(cave_generator.cave_height / 2.0) * tile_size
	camera.limit_bottom = (int(cave_generator.cave_height / 2.0) + 1) * tile_size
	tile_map.add_child(camera)
	
	# Exit
	exit = scene_exit.instantiate()
	exit.position = cave_generator.exit_spawn_pos
	tile_map.add_child(exit)
