@tool
class_name Hand
extends Node3D

enum Axis {
	Z_AXIS,
	Y_AXIS
}

## Axis in which the pickaxe faces
@export var axis: Axis
## The current angle (in degrees) at which the hand is rotated
@export_range(0, 360) var angle: float = 0
## The height (in meters) at which the pickaxe will no longer clip through the floor
@export var height: float = 1.5
## The distance (in meters) at which the pickaxe will be from the player
@export var distance: float = 2
## The height (in pixels) at which the pickaxe will appear to pivot around
@export var pixel_height: float = 6
@export_group("Nodes")
@export var pickaxe: Node3D
@export var pickaxe_sprite: Sprite3D
@export var hitbox_pivot: Node3D

func _physics_process(_delta: float) -> void:
	# Currently testing out 2 different methods:
	# Rotation in the Z axis and rotation in the Y axis
	match axis:
		Axis.Z_AXIS:
			rotate_z_axis()
		Axis.Y_AXIS:
			rotate_y_axis()

func rotate_z_axis() -> void:
	position.y = height
	position.z = height - (pixel_height * Globals.PIXEL_SIZE)
	rotation_degrees.y = angle
	
	pickaxe.rotation_degrees.y = -angle
	pickaxe.rotation_degrees.z = angle
	pickaxe.position.z = distance - position.z
	
	pickaxe_sprite.axis = Vector3.AXIS_Z
	pickaxe_sprite.rotation_degrees.y = 0
	pickaxe_sprite.rotation_degrees.z = -135
	
	hitbox_pivot.rotation_degrees.y = angle

func rotate_y_axis() -> void:
	position.y = pixel_height * Globals.PIXEL_SIZE
	position.z = 0
	rotation_degrees.y = angle
	
	pickaxe.rotation_degrees.y = 0
	pickaxe.rotation_degrees.z = 0
	pickaxe.position.z = distance
	
	pickaxe_sprite.axis = Vector3.AXIS_Y
	pickaxe_sprite.rotation_degrees.y = -135
	pickaxe_sprite.rotation_degrees.z = 0
	
	hitbox_pivot.rotation_degrees.y = angle
