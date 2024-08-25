@tool
class_name Hand
extends Node3D

@export_range(0, 360) var angle: float = 0:
	set(new_value):
		angle = new_value
		update_rotation()
@export_range(0, 20) var body_radius: float = 6:
	set(new_value):
		body_radius = distance if new_value > distance else new_value
		update_positions()
@export_range(0, 20) var distance: float = 12:
	set(new_value):
		distance = body_radius if new_value < body_radius else new_value
		update_positions()
@export_range(0, 20) var height: float = 5:
	set(new_value):
		height = new_value
		update_positions()
@export_group("Nodes")
@export var actor: CharacterBody3D
@export var pickaxe: Node3D
@export var pickaxe_sprite: Sprite3D
@export var hitbox_pivot: Node3D

func _ready() -> void:
	update_positions()

func update_positions() -> void:
	#if not is_node_ready(): return
	# Offset pickaxe from hand origin by distance
	pickaxe.position.z = distance * Globals.PIXEL_SIZE
	# Position hand origin
	position.z = pickaxe.position.z - (body_radius * Globals.PIXEL_SIZE)
	position.y = position.z + (height * Globals.PIXEL_SIZE)

func update_rotation() -> void:
	if not is_node_ready(): return
	# Rotate hand
	rotation_degrees.y = angle
	# Rotate pickaxe to match hand rotation
	pickaxe.rotation_degrees.y = -angle
	pickaxe.rotation_degrees.z = angle
	# Rotate hitbox
	hitbox_pivot.rotation_degrees.y = angle

func rotate_towards(target_pos: Vector3) -> void:
	var direction: Vector3 = actor.to_local(Vector3(target_pos.x, 0, target_pos.z))
	direction += Vector3.BACK * height * Globals.PIXEL_SIZE
	angle = rad_to_deg(Vector2(direction.x, direction.z).angle_to(Vector2.DOWN))
