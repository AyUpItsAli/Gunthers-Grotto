extends Camera3D

@export var target: Node3D
@export var height: float = 7
@export var distance: float = 10
@export var smooth_weight: float = 0.1

func _physics_process(_delta):
	if not target or target.is_queued_for_deletion():
		return
	position.x = lerp(position.x, target.position.x, smooth_weight)
	position.y = height
	position.z = target.position.z + distance
	look_at(Vector3(position.x, target.position.y, target.position.z))
