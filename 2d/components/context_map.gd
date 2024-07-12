class_name ContextMap
extends Node2D

@export var vector_count: int = 12
@export var ray_length: float = 20
@export_flags_2d_physics var ray_collision_mask: int

var directions: Array[Vector2]
var rays: Array[RayCast2D]
var interest_map: Array[float]

func _ready() -> void:
	for i in range(vector_count):
		var angle: float = i * 2 * (PI / vector_count)
		var direction := Vector2.UP.rotated(angle)
		directions.append(direction)
		var ray := RayCast2D.new()
		ray.target_position = direction * ray_length
		ray.collision_mask = ray_collision_mask
		add_child(ray)
		rays.append(ray)
	interest_map.resize(vector_count)

func set_interests(target_vectors: Array[Vector2]) -> void:
	for i in range(vector_count):
		var interest: float = 0
		for vector in target_vectors:
			interest += directions[i].dot(vector)
		interest_map[i] = max(0, interest)

func get_desired_vector() -> Vector2:
	var desired_vector := Vector2.ZERO
	for i in range(vector_count):
		var interest: float = interest_map[i]
		if rays[i].is_colliding():
			interest = 0
		desired_vector += directions[i] * interest
	return desired_vector.normalized()
