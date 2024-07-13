@tool
extends SubViewportContainer

@warning_ignore("unused_private_class_variable")
@export var _update_viewport: bool = true:
	set(new_value):
		_update_viewport = true
		update_viewport()

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
