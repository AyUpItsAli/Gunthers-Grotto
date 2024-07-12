class_name Gunther
extends CharacterBody2D

@export var max_speed: float = 100
@export var acceleration: float = 10
@export var sprite: Sprite2D

signal died

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.move_toward(direction * max_speed, acceleration)
	move_and_slide()

func _on_hurtbox_hit() -> void:
	var color_before: Color = sprite.modulate
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = color_before
	sprite.modulate.a = 0.5

func _on_hurtbox_immunity_ended() -> void:
	sprite.modulate.a = 1

func _on_health_depleted() -> void:
	die()

func die() -> void:
	died.emit()
	queue_free()
