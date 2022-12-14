class_name RockHermitChaseState
extends RockHermitState

const TEXTURE_RIGHT = preload("res://Assets/Actors/Enemies/Rock_Hermit_Right.png")
const TEXTURE_LEFT = preload("res://Assets/Actors/Enemies/Rock_Hermit_Left.png")
const MAX_SPEED = 3500
const MAX_STEERING = 5
const AVOID_FORCE = MAX_SPEED
const STOP_DISTANCE = 25
const ATTACK_DAMAGE = 1

func enter(ctx: Dictionary = {}):
	if not ctx.has("target"): return state_machine.enter_state("Hidden")
	enemy.target = ctx["target"]

func update(delta):
	update_sprite()
	enemy.hurtbox.look_at(enemy.target.position)

func attack():
	var areas = enemy.hurtbox.get_overlapping_areas()
	if areas.size() > 0 and enemy.attack_cooldown_timer.is_stopped():
		var hitbox: Area2D = areas[0]
		var attackee = hitbox.get_parent()
		if attackee.has_method("take_damage"):
			attackee.take_damage(enemy, ATTACK_DAMAGE)
		enemy.attack_cooldown_timer.start()

func update_sprite():
	if enemy.target.position.x > enemy.position.x:
		enemy.body_sprite.texture = TEXTURE_RIGHT
	elif enemy.target.position.x < enemy.position.x:
		enemy.body_sprite.texture = TEXTURE_LEFT
	elif enemy.body_sprite.texture != TEXTURE_RIGHT and enemy.body_sprite.texture != TEXTURE_LEFT:
		enemy.body_sprite.texture = Utils.choose_from([TEXTURE_RIGHT, TEXTURE_LEFT])

func physics_update(delta):
	var steering = get_seek_steering(delta)
	steering += enemy.soft_collision.get_push_vector() * AVOID_FORCE * delta
	steering = steering.limit_length(MAX_STEERING)
	
	enemy.velocity += steering
	enemy.velocity = enemy.velocity.limit_length(MAX_SPEED * delta)
	
	enemy.velocity = enemy.move_and_slide(enemy.velocity)

func get_seek_steering(delta) -> Vector2:
	var desired_velocity = Vector2.ZERO
	var direction = get_seek_direction()
	if direction == Vector2.ZERO: # Enemy is unable to locate the target
		state_machine.enter_state("Hidden")
	elif enemy.position.distance_to(enemy.target.position) > STOP_DISTANCE:
		desired_velocity = direction * MAX_SPEED * delta
	return desired_velocity - enemy.velocity

func get_seek_direction() -> Vector2:
	enemy.target_ray.cast_to = enemy.target.position - enemy.position
	enemy.target_ray.force_raycast_update()
	
	if !enemy.target_ray.is_colliding():
		enemy.last_known_location = enemy.target.position
		return enemy.target_ray.cast_to.normalized()
	else:
		for player_scent in enemy.target.scent_trail:
			enemy.target_ray.cast_to = player_scent.position - enemy.position
			enemy.target_ray.force_raycast_update()
	
			if !enemy.target_ray.is_colliding():
				enemy.last_known_location = player_scent.position
				return enemy.target_ray.cast_to.normalized()
	
	enemy.target_ray.cast_to = enemy.last_known_location - enemy.position
	enemy.target_ray.force_raycast_update()
	var distance = enemy.position.distance_to(enemy.last_known_location)
	if !enemy.target_ray.is_colliding() and distance > STOP_DISTANCE:
		return enemy.target_ray.cast_to.normalized()
	return Vector2.ZERO

func take_damage(attacker, damage: int):
	enemy.body_sprite.modulate = Color.red
	enemy.health -= damage
	if enemy.health < 0: enemy.health = 0
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.body_sprite.modulate = Color.white
	if enemy.health == 0:
		state_machine.enter_state("Dead")
