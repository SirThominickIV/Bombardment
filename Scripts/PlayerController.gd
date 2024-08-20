extends Node

var tilemap
var weaponController

var selectedProjectile = ProjectileDefs.RodsFromTheGods

# Using physics processing to keep deletion consistent
func _physics_process(delta):
	
	if(Input.is_action_just_pressed("mb_left")):	
		#spawnProjectile(random.randi_range(0,1))
		weaponController.spawnProjectile(selectedProjectile)

