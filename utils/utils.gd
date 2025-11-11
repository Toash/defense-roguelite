class_name Utils

static func rad_to_unit_vector(rad: float) -> Vector2:
    var direction = Vector2(cos(rad), sin(rad))
    direction = direction.normalized()
    return direction
