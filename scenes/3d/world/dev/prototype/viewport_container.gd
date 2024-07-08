@tool
extends SubViewportContainer

@warning_ignore("unused_private_class_variable")
@export var _correct_foreshortening: bool = true:
	set(new_value):
		correct_foreshortening()
@export var viewport: SubViewport
@export var camera: Camera3D

func correct_foreshortening():
	scale.y = sqrt(2)
	position.y = -(size.y * (sqrt(2)-1)) / 2

func _ready():
	correct_foreshortening()
