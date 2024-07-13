extends SubViewportContainer

func _ready() -> void:
	Globals.controllers_changed.connect(update_viewport)
	update_viewport()

func update_viewport() -> void:
	if Globals.camera_controller == Globals.Controller.PLAYER:
		scale.y = sqrt(2)
		position.y = -(size.y * (sqrt(2)-1) / 2.0)
	else:
		scale.y = 1
		position.y = 0
