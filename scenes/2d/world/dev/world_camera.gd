extends Camera2D

@export_category("Camera Controls")
@export var initial_zoom: float = 0.5
@export var min_zoom: float = 0.1
@export var max_zoom: float = 1
@export var increment: float = 0.1

func _ready():
	zoom = Vector2(initial_zoom, initial_zoom)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom
	elif event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					zoom.x = max(zoom.x - increment * zoom.x, min_zoom)
				MOUSE_BUTTON_WHEEL_UP:
					zoom.x = min(zoom.x + increment * zoom.x, max_zoom)
			zoom.y = zoom.x
