@tool
extends Camera3D

@export var target: Node3D
@export var y_offset: float = 6
@export var z_offset: float = 10
@export var smooth_weight: float = 0.1

func _physics_process(_delta):
	if not target or target.is_queued_for_deletion():
		return
	position.x = lerp(position.x, target.position.x, smooth_weight)
	position.y = target.position.z + y_offset
	position.z = target.position.z + z_offset
	look_at(Vector3(position.x, target.position.y, target.position.z))
