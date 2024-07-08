@tool
extends SubViewportContainer

@warning_ignore("unused_private_class_variable")
@export var _update_viewport: bool = true:
	set(new_value):
		_update_viewport = true
		update_viewport()
@export var viewport: SubViewport
@export var camera: Camera3D
@export var foreshortening_correction: bool = true

func update_viewport():
	if foreshortening_correction:
		scale.y = sqrt(2)
		position.y = -(size.y * (sqrt(2)-1)) / 2
	else:
		scale.y = 1
		position.y = 0

func _ready():
	update_viewport()
