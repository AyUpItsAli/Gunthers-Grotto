extends Node3D

@export var actor: CharacterBody3D
@export_group("Nodes")
@export var sprite_pivot: MeleeWeaponSpritePivot
@export var hitbox_pivot: Node3D
@export var animation_player: AnimationPlayer

func _physics_process(_delta: float) -> void:
	var mouse_pos: Vector3 = PlayerCamera.get_mouse_pos(self)
	var direction: Vector3 = actor.to_local(Vector3(mouse_pos.x, 0, mouse_pos.z))
	sprite_pivot.rotate_in_direction(direction)
	hitbox_pivot.rotation_degrees.y = sprite_pivot.angle

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_use") and not animation_player.is_playing():
		animation_player.play("attack")
