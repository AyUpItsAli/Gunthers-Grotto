extends CharacterBody3D

@export_group("Nodes")
@export var sight_area: Area3D
@export var sight_line: RayCast3D
@export var state_chart: StateChart

var target: CharacterBody3D

func target_exists() -> bool:
	if not target:
		return false
	return not target.is_queued_for_deletion()

func can_see_pos(pos: Vector3) -> bool:
	pos.y = sight_line.global_position.y
	sight_line.target_position = sight_line.to_local(pos)
	sight_line.force_raycast_update()
	return not sight_line.is_colliding()

func _on_idiling_state_entered() -> void:
	target = null

func _on_idiling_state_physics_processing(_delta: float) -> void:
	if target_exists():
		state_chart.send_event("target_spotted")
	elif sight_area.has_overlapping_bodies():
		var body: Node3D = sight_area.get_overlapping_bodies().front()
		if body is CharacterBody3D and can_see_pos(body.position):
			target = body
			state_chart.send_event("target_spotted")
