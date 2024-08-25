@tool
class_name PlayerCamera
extends Camera3D

@export var target: Node3D
@export var smooth_weight: float = 0.1

func _physics_process(_delta: float) -> void:
	if not target or target.is_queued_for_deletion():
		return
	position.x = lerp(position.x, target.position.x, smooth_weight)
	position.z = lerp(position.z, target.position.z + size, smooth_weight)
	position.y = lerp(position.y, target.position.y + size, smooth_weight)

func get_mouse_pos() -> Vector3:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = project_ray_origin(mouse_pos)
	var to: Vector3 = from + project_ray_normal(mouse_pos) * 100
	var result: Variant = Plane.PLANE_XZ.intersects_segment(from, to)
	return Vector3.ZERO if result == null else result
