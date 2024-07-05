class_name Camera
extends Camera2D

var target: Node2D

@export var smooth_weight: float = 0.05

func _physics_process(_delta):
	if not target or target.is_queued_for_deletion():
		return
	global_position = global_position.lerp(target.global_position, smooth_weight)
