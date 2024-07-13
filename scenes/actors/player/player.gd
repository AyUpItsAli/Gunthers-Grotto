extends CharacterBody3D

@export var max_speed: float = 5
@export var acceleration: float = 0.5
@export var sprite: Sprite3D
@export var hand: Node3D
@export var pickaxe: Node3D
@export var hitbox_pivot: Node3D

var spin: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		spin = not spin

func _physics_process(_delta: float) -> void:
	# Movement
	if Globals.movement_controller == Globals.Controller.PLAYER:
		var direction_2d: Vector2 = Input.get_vector("left", "right", "forward", "back") # Move direction in 2d space
		var direction := Vector3(direction_2d.x, 0, direction_2d.y) # Move direction in 3d space
		velocity = velocity.move_toward(direction * max_speed, acceleration)
		move_and_slide()
	
	# Rotate hand
	if hand.rotation_degrees.y >= 360:
		hand.rotation_degrees.y = 0
	elif spin:
		hand.rotation_degrees.y = move_toward(hand.rotation_degrees.y, 360, 0.5)
	
	# Rotate the pickaxe to match the motion of the hand rotation
	#pickaxe.rotation_degrees.y = -hand.rotation_degrees.y
	#pickaxe.rotation_degrees.z = hand.rotation_degrees.y - 90 - 45
	
	# Render player sprite above pickaxe sprite if hand is behind player
	# This is a work around for a bug todo with how Godot renders transparent meshes
	#sprite.render_priority = 1 if hand.rotation_degrees.y > 90 and hand.rotation_degrees.y < 270 else 0
	
	hitbox_pivot.rotation_degrees = hand.rotation_degrees
