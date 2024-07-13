class_name ContextMap
extends Node3D

@export var vector_count: int = 12
@export var ray_length: float = 1.5
@export_flags_3d_physics var collision_mask: int

var directions: Array[Vector3]
var rays: Array[RayCast3D]
var interest_map: Array[float]

func _ready() -> void:
	for i in range(vector_count):
		var angle: float = i * 2 * (PI / vector_count)
		var direction := Vector3.FORWARD.rotated(Vector3.UP, angle)
		directions.append(direction)
		var ray := RayCast3D.new()
		ray.target_position = direction * ray_length
		ray.collision_mask = collision_mask
		add_child(ray)
		rays.append(ray)
	interest_map.resize(vector_count)

func set_interests(target_vectors: Array[Vector3]) -> void:
	for i in range(vector_count):
		var interest: float = 0
		for vector in target_vectors:
			interest += directions[i].dot(Vector3(vector.x, 0, vector.z))
		interest_map[i] = max(0, interest)

func get_desired_vector() -> Vector3:
	var desired_vector := Vector3.ZERO
	for i in range(vector_count):
		var interest: float = interest_map[i]
		if rays[i].is_colliding():
			interest = 0
		desired_vector += directions[i] * interest
	return desired_vector.normalized()
