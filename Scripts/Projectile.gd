extends RigidBody2D
class_name Projectile

var real_world_target_coords = Vector2i(0,0)
var tilemap_target_coords = Vector2i(0,0)
var projectile_type = 0

@onready var mainController: MainController = get_node('/root/MainController') as MainController
var selectorController: SelectorController

func _ready() -> void:
	selectorController = mainController.get_controller(ControllerDefs.Controllers.SelectorController)

func _process(_delta):
	if(position.y > real_world_target_coords.y):
		handle_collision()

func remove() -> void:
	selectorController.remove_targeted_tile(tilemap_target_coords)
	
	# Delete the projectile
	queue_free()

func handle_collision():
	
	var explosion = Object
	
	# Do the associated damage type & explosion
	match projectile_type:
		ProjectileDefs.StandardArtillery:
			get_parent().do_standard_artillery_damage(tilemap_target_coords)
			explosion = SceneDefs.Explosion.instantiate()
		ProjectileDefs.Nuke:
			get_parent().do_nuke_damage(tilemap_target_coords)
			explosion = SceneDefs.NuclearExplosion.instantiate()
		ProjectileDefs.RodsFromTheGods:
			get_parent().do_rods_from_the_gods_damage(tilemap_target_coords)
			explosion = SceneDefs.NuclearExplosion.instantiate()
		ProjectileDefs.Incendiary:
			get_parent().do_incendiary_damage(tilemap_target_coords)
			explosion = SceneDefs.Explosion.instantiate()
		_:
			get_parent().do_standard_artillery_damage(tilemap_target_coords)
			explosion = SceneDefs.Explosion.instantiate()

	# Pass off the explosion object to the parent
	# so it is not erased, and set the position
	explosion.position = real_world_target_coords
	get_parent().add_child((explosion))
	
	remove()
