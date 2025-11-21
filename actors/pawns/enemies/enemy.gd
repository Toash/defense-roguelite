extends Pawn


## contains centralized data for an enemy 

# Enemies will have specific balancing for:
	# Spawn cost 
	# Health 
	# Movespeed
	# Attack Speed  
	# Attack Damage 
class_name Enemy

@export var enemy_data: EnemyData


func setup(data: EnemyData):
	enemy_data = data
	self.health.set_max_health(int(data.health))
	self.health.set_health(data.health)
