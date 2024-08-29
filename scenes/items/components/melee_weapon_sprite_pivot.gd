@tool
class_name MeleeWeaponSpritePivot
extends Node3D

@export var _update: bool = true:
	set(new_value):
		_update = true
		update_positions()
		update_rotation()
@export_range(0, 360) var angle: float = 0:
	set(new_value):
		angle = new_value
		update_rotation()
@export_range(0, 50) var distance: float = 12:
	set(new_value):
		distance = body_radius if new_value < body_radius else new_value
		update_positions()
@export_category("Actor")
@export_range(0, 20) var body_radius: float = 6:
	set(new_value):
		body_radius = distance if new_value > distance else new_value
		update_positions()
@export_range(0, 20) var pivot_height: float = 5:
	set(new_value):
		pivot_height = new_value
		update_positions()

func _ready() -> void:
	update_positions()

func update_positions() -> void:
	if not is_node_ready(): return
	if get_child_count() < 1: return
	var sprite_parent: Node = get_child(0)
	if not sprite_parent is Node3D: return
	# Offset sprite group from sprite pivot by distance
	sprite_parent.position.z = distance * Globals.PIXEL_SIZE
	# Set sprite pivot origin
	self.position.z = sprite_parent.position.z - (body_radius * Globals.PIXEL_SIZE)
	self.position.y = self.position.z + (pivot_height * Globals.PIXEL_SIZE)

func update_rotation() -> void:
	if not is_node_ready(): return
	if get_child_count() < 1: return
	var sprite_parent: Node = get_child(0)
	if not sprite_parent is Node3D: return
	# Rotate sprite pivot
	self.rotation_degrees.y = angle
	# Rotate sprite group to match sprite pivot
	sprite_parent.rotation_degrees.y = -angle
	sprite_parent.rotation_degrees.z = angle

func rotate_in_direction(direction: Vector3) -> void:
	direction += Vector3.BACK * pivot_height * Globals.PIXEL_SIZE
	angle = rad_to_deg(Vector2(direction.x, direction.z).angle_to(Vector2.DOWN))
