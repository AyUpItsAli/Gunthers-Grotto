class_name Hitbox
extends Area3D

@export var damage: float = 1

func trigger() -> void:
	for area in get_overlapping_areas():
		pass
