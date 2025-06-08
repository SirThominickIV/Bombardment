extends RigidBody2D
class_name Projectile

var target_coord = Vector2i(0,0)
var projectile_type = 0

func _process(_delta):
	if(position.y > target_coord.y):
		handle_collision()
		queue_free()

func handle_collision():
	
	var explosion = Object
	
	# Do the associated damage type & explosion
	match projectile_type:
		ProjectileDefs.StandardArtillery:
			get_parent().do_standard_artillery_damage(target_coord)
			explosion = SceneDefs.Explosion.instantiate()	
		ProjectileDefs.Nuke:
			get_parent().do_nuke_damage(target_coord)
			explosion = SceneDefs.NuclearExplosion.instantiate()	
		ProjectileDefs.RodsFromTheGods:
			get_parent().do_rods_from_the_gods_damage(target_coord)
			explosion = SceneDefs.NuclearExplosion.instantiate()
		ProjectileDefs.Incendiary:
			get_parent().do_incendiary_damage(target_coord)
			explosion = SceneDefs.Explosion.instantiate()	
		_:
			get_parent().do_standard_artillery_damage(target_coord)
			explosion = SceneDefs.Explosion.instantiate()	

	# Pass off the explosion object to the parent
	# so it is not erased, and set the position
	explosion.position = target_coord
	get_parent().add_child((explosion))
	
	# Delete the projectile
	queue_free()
