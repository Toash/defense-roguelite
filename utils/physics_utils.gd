class_name PhysicsUtils
static func compute_intercept_time(origin: Vector2, target: Vector2, target_velocity: Vector2, projectile_speed: float) -> float:
	var r = target - origin

	var vv = target_velocity.dot(target_velocity)
	var rv = r.dot(target_velocity)
	var rr = r.dot(r)

	var a = vv - projectile_speed * projectile_speed
	var b = rv
	var c = rr

	# handle nearly-equal speeds or degenerate case
	if abs(a) < 0.0001:
		return -1.0 # fallback: treat as "no predictive solution"

	var disc = b * b - a * c
	if disc < 0.0:
		return -1.0 # no real solution

	var sqrt_disc = sqrt(disc)

	var t1 = (-b + sqrt_disc) / a
	var t2 = (-b - sqrt_disc) / a

	var best_t = INF
	if t1 > 0.0:
		best_t = t1
	if t2 > 0.0 and t2 < best_t:
		best_t = t2

	return best_t if best_t < INF else -1.0

# predict target place with projectile and target velocity
static func compute_predicted_target(origin: Vector2, target: Vector2, target_velocity: Vector2, projectile_speed: float) -> Vector2:
	var t = compute_intercept_time(origin, target, target_velocity, projectile_speed)
	if t > 0.0:
		var aim_pos: Vector2 = target + target_velocity * t
		# var dir = (aim_pos - P).normalized()
		# fire in dir
		return aim_pos
	else:
		return target
	# fallback: just aim directly at current position