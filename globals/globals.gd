extends Node

const PIXEL_SIZE: float = 0.125 # 1 pixel is 0.125 meters or 1/8 of a meter
const TILE_SIZE_PIXELS: float = 16 # 1 tile is 16x16 pixels or 2x2 meters
const TILE_SIZE_METERS: float = PIXEL_SIZE * TILE_SIZE_PIXELS
const SEED_CHARS: String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

enum Controller { PLAYER, FREE_CAM }
var camera_controller: Controller = Controller.PLAYER
var movement_controller: Controller = Controller.PLAYER

signal controllers_changed

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_camera"):
		match camera_controller:
			Controller.PLAYER:
				camera_controller = Controller.FREE_CAM
				movement_controller = Controller.FREE_CAM
			Controller.FREE_CAM:
				camera_controller = Controller.PLAYER
				movement_controller = Controller.PLAYER
		controllers_changed.emit()
	elif camera_controller == Controller.FREE_CAM and event.is_action_pressed("toggle_movement"):
		match movement_controller:
			Controller.PLAYER:
				movement_controller = Controller.FREE_CAM
			Controller.FREE_CAM:
				movement_controller = Controller.PLAYER
		controllers_changed.emit()
