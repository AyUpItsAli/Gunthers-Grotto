class_name HitboxOld
extends Area2D

@export var damage: float = 1

func trigger() -> void:
	for area in get_overlapping_areas():
		if area is HurtboxOld:
			area.hurt(damage)
