extends RigidBody2D

var TargetCoord = Vector2(0,0)
var ProjectileType = 0

func _process(delta):
	if(position.y > TargetCoord.y):
		handleCollision()
		queue_free()

func handleCollision():
	
	var explosion = Object
	
	# Do the associated damage type & explosion
	match ProjectileType:
		ProjectileDefs.StandardArtillery:
			get_parent().doStandardArtilleryDamage(TargetCoord)
			explosion = SceneDefs.Explosion.instantiate()	
		ProjectileDefs.Nuke:
			get_parent().doNukeDamage(TargetCoord)
			explosion = SceneDefs.NuclearExplosion.instantiate()	
		ProjectileDefs.RodsFromTheGods:
			get_parent().doRodsFromTheGodsDamage(TargetCoord)
			explosion = SceneDefs.NuclearExplosion.instantiate()	
		_:
			get_parent().doStandardArtilleryDamage(TargetCoord)
			explosion = SceneDefs.Explosion.instantiate()	

	# Pass off the explosion object to the parent
	# so it is not erased, and set the position
	explosion.position = TargetCoord
	get_parent().add_child((explosion))
	
	# Delete the projectile
	queue_free()
