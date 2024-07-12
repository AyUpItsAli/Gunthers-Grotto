class_name Health
extends Node

@export var max_health: int = 10

@onready var health: float = max_health

signal depleted

func damage(amount: float) -> void:
	health = max(0, health - amount)
	if health <= 0:
		depleted.emit()
