class_name Faction

enum Type {
	NEUTRAL,
	HUMAN,
	ENEMY
}


static func can_hit(hitter: Type, hittee: Type) -> bool:
    if hitter == hittee:
        return false
    else:
        return true
