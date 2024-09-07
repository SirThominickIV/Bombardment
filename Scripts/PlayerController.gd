extends Node
class_name PlayerController

var tilemap
var weaponController

var selectedProjectile = ProjectileDefs.StandardArtillery
var isMouseOverUI : bool = false

func _process(delta):
	
	if(Input.is_action_just_pressed("mb_left") && !isMouseOverUI):	
		weaponController.spawnProjectile(selectedProjectile)
