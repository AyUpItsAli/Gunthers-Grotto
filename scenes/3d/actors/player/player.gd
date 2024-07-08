extends CharacterBody3D

@export var max_speed: float = 5
@export var acceleration: float = 0.5
@export var hand: Node3D
@export var pickaxe: Node3D

var spin: bool

func _unhandled_input(event):
	if event.is_action_pressed("test"):
		spin = not spin

func _physics_process(_delta):
	var direction_2d = Input.get_vector("left", "right", "up", "down")
	var direction = Vector3(direction_2d.x, 0, direction_2d.y)
	velocity = velocity.move_toward(direction * max_speed, acceleration)
	move_and_slide()
	if hand.rotation.y >= deg_to_rad(360):
		hand.rotation.y = 0
	elif spin:
		hand.rotation.y = move_toward(hand.rotation.y, deg_to_rad(360), 0.01)
	
	pickaxe.rotation.y = -hand.rotation.y
	pickaxe.rotation.z = deg_to_rad(-90) + hand.rotation.y
