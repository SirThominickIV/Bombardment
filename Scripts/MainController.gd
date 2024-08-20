extends Node2D

var tilemap: TileMap

var welwalaController
var playerController
var weaponController
var cameraController

func _ready():
	# TODO : Eventually the level that gets loaded should be
	# handled through UI. For now this works.
	tilemap = SceneDefs.Levels[0].instantiate()
	add_child(tilemap)
	
	# Set up controllers
	welwalaController = SceneDefs.WelwalaController.instantiate()
	weaponController = SceneDefs.WeaponController.instantiate()
	playerController = SceneDefs.PlayerController.instantiate()
	playerController.weaponController = weaponController
	cameraController = SceneDefs.CameraController.instantiate()
	add_child(welwalaController)	
	add_child(weaponController)
	add_child(playerController)
	add_child(cameraController)
	
	HandOutTileMap()
	
	# Turn off the mouse cursor when inside the window
	# Eventually this will need to be turned back on when hovering over
	# UI panels/elements, but this is better for now
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
 
# A variety of controllers will need the tilemap, and that behaviour will 
# need repeated every time a level is loaded. This function will handle that.
func HandOutTileMap():
	welwalaController.tilemap = tilemap
	weaponController.tilemap = tilemap

