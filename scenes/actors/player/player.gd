extends CharacterBody3D

@export var max_speed: float = 8
@export var acceleration: float = 1
@export_group("Nodes")
@export var sprite: Sprite3D

signal died

func _physics_process(_delta: float) -> void:
	# Movement
	if Globals.movement_controller == Globals.Controller.PLAYER:
		var direction_2d: Vector2 = Input.get_vector("left", "right", "forward", "back") # Move direction in 2d space
		var direction := Vector3(direction_2d.x, 0, direction_2d.y) # Move direction in 3d space
		velocity = velocity.move_toward(direction * max_speed, acceleration)
		move_and_slide()

func _on_hurtbox_hit() -> void:
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func _on_health_depleted() -> void:
	died.emit()
	queue_free()
