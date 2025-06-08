extends RigidBody2D
class_name Projectile

var TargetCoord = Vector2(0,0)
var ProjectileType = 0

func _process(_delta):
	if(position.y > TargetCoord.y):
		handleCollision()
		queue_free()

func handleCollision():
	
	var explosion = Object
	
	# Do the associated damage type & explosion
	match ProjectileType:
		ProjectileDefs.StandardArtillery:
			get_parent().do_standardartillery_damage(TargetCoord)
			explosion = SceneDefs.Explosion.instantiate()	
		ProjectileDefs.Nuke:
			get_parent().do_nuke_damage(TargetCoord)
			explosion = SceneDefs.NuclearExplosion.instantiate()	
		ProjectileDefs.RodsFromTheGods:
			get_parent().do_rods_from_the_gods_damage(TargetCoord)
			explosion = SceneDefs.NuclearExplosion.instantiate()
		ProjectileDefs.Incendiary:
			get_parent().do_incendiary_damage(TargetCoord)
			explosion = SceneDefs.Explosion.instantiate()	
		_:
			get_parent().do_standardartillery_damage(TargetCoord)
			explosion = SceneDefs.Explosion.instantiate()	

	# Pass off the explosion object to the parent
	# so it is not erased, and set the position
	explosion.position = TargetCoord
	get_parent().add_child((explosion))
	
	# Delete the projectile
	queue_free()
