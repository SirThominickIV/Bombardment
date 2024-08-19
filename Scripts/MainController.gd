extends Node2D

var tilemap
var welwalaController

func _ready():
	# TODO : Eventually the level that gets loaded should be
	# handled through UI. For now this works.
	tilemap = SceneDefs.level01.instantiate()
	add_child(tilemap)
	
	# Set up controllers
	welwalaController = SceneDefs.WelwalaController.instantiate()
	add_child(welwalaController)
	
	HandOutTileMap()
	
	# Turn off the mouse cursor when inside the window
	# Eventually this will need to be turned back on when hovering over
	# UI panels/elements, but this is better for now
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
 
# A variety of controllers will need the tilemap, and that behaviour will 
# need repeated every time a level is loaded. This function will handle that.
func HandOutTileMap():
	welwalaController.tilemap = tilemap

