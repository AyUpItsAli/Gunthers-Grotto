class_name Hitbox
extends Area3D

@export var damage: float = 1

func _on_area_entered(area: Area3D) -> void:
	if area is Hurtbox:
		area.hurt(damage)
