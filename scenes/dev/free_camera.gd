class_name FreeCamera
extends Camera3D

@export var max_speed: float = 5
@export var acceleration: float = 25
@export var look_speed: float = 300

var velocity: Vector3
var angles: Vector2

func _physics_process(delta: float) -> void:
	if not current: return
	if not Globals.free_camera_enabled: return
	
	angles.y = clamp(angles.y, PI / -2.0, PI / 2.0)
	rotation = Vector3(angles.y, angles.x, 0)
	
	var direction_2d: Vector2 = Input.get_vector("left", "right", "forward", "back")
	var direction := Vector3(direction_2d.x, 0, direction_2d.y)
	if Input.is_action_pressed("free_cam_up"):
		direction += Vector3.UP
	if Input.is_action_pressed("free_cam_down"):
		direction += Vector3.DOWN
	
	velocity = velocity.move_toward(direction * max_speed, acceleration)
	translate(velocity * delta)

func _unhandled_input(event: InputEvent) -> void:
	if not current: return
	if event.is_action_pressed("toggle_free_cam"):
		Globals.free_camera_enabled = not Globals.free_camera_enabled
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Globals.free_camera_enabled else Input.MOUSE_MODE_VISIBLE
		angles.x = rotation.y
		angles.y = rotation.x
	elif Globals.free_camera_enabled and event is InputEventMouseMotion:
		angles -= event.relative / look_speed
