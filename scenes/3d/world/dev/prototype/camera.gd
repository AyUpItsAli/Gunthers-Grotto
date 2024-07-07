@tool
extends Camera3D

@export var target: Node3D
@export_range(0, 30) var y_offset: float = 6
@export_range(0, 30) var z_offset: float = 10
@export var smooth_weight: float = 0.1

func _physics_process(_delta):
	if not target or target.is_queued_for_deletion():
		return
	position.x = lerp(position.x, target.position.x, smooth_weight)
	position.z = lerp(position.z, target.position.z + z_offset, smooth_weight)
	position.y = lerp(position.y, target.position.y + y_offset, smooth_weight)
	if z_offset == 0:
		rotation.x = deg_to_rad(-90)
	else:
		look_at(Vector3(position.x, position.y - y_offset, position.z - z_offset))
