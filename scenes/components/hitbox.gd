class_name Hitbox
extends Area2D

@export var damage: float = 1

func trigger():
	for area in get_overlapping_areas():
		if area is Hurtbox:
			area.hurt(damage)
