extends CharacterBody2D

@export var max_speed: float = 85
@export var steering_force: float = 0.1
@export var rotation_weight: float = 0.05
@export_category("Nodes")
@export var sight_area: Area2D
@export var sight_line: RayCast2D
@export var nav_agent: NavigationAgent2D
@export var context_map: Node3D
@export var hitbox: HitboxOld
@export var cooldown_timer: Timer
@export var anim_player: AnimationPlayer
@export var state_chart: StateChart

var target: CharacterBody2D

func target_exists() -> bool:
	if not target:
		return false
	return not target.is_queued_for_deletion()

func can_see_pos(pos: Vector2) -> bool:
	sight_line.target_position = to_local(pos)
	sight_line.force_raycast_update()
	return not sight_line.is_colliding()

func _on_idling_state_entered() -> void:
	target = null

func _on_idling_state_physics_processing(_delta: float) -> void:
	if target_exists():
		state_chart.send_event("target_spotted")
	elif sight_area.has_overlapping_bodies():
		var body: Node2D = sight_area.get_overlapping_bodies().front()
		if can_see_pos(body.position):
			target = body
			state_chart.send_event("target_spotted")

func _on_chasing_state_physics_processing(_delta: float) -> void:
	if not target_exists():
		state_chart.send_event("target_lost")
		return
	if hitbox.has_overlapping_areas() and cooldown_timer.is_stopped():
		state_chart.send_event("attack")
		return
	nav_agent.target_position = target.position
	var target_vector: Vector2 = to_local(nav_agent.get_next_path_position()).normalized()
	hitbox.rotation = lerp_angle(hitbox.rotation, target_vector.angle(), rotation_weight)
	context_map.set_interests([target_vector])
	nav_agent.velocity = context_map.get_desired_vector() * max_speed
	nav_agent.max_speed = max_speed

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.lerp(safe_velocity, steering_force)
	move_and_slide()

func _on_chasing_state_exited() -> void:
	nav_agent.velocity = Vector2.ZERO

func _on_attacking_state_entered() -> void:
	anim_player.play("Attack")
	await anim_player.animation_finished
	state_chart.send_event("attack_finished")
	cooldown_timer.start()
