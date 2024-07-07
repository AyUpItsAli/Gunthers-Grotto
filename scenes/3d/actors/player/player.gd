extends CharacterBody3D

@export var max_speed: float = 5
@export var acceleration: float = 0.5

func _physics_process(_delta):
	var direction_2d = Input.get_vector("left", "right", "up", "down")
	var direction = Vector3(direction_2d.x, 0, direction_2d.y)
	velocity = velocity.move_toward(direction * max_speed, acceleration)
	move_and_slide()
