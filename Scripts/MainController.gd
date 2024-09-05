extends Node2D
class_name MainController

var level

var welwalaController
var playerController
var weaponController
var cameraController
var fireController
var selectorController
var mainUI

var tilemap : ExtendedTilemap = ExtendedTilemap.new()

func _ready():
	# TODO : Eventually the level that gets loaded should be
	# handled through UI. For now this works.
	level = SceneDefs.Levels[0].instantiate()
	add_child(level)
	
	# Combine tile map layers
	tilemap.DestroyedTiles = level.get_node("/root/MainController/Level/" + LayerDefs.DestroyedTiles)
	tilemap.ToBuildTiles = level.get_node("/root/MainController/Level/" + LayerDefs.ToBuildTiles)
	tilemap.Water = level.get_node("/root/MainController/Level/" + LayerDefs.Water)
	tilemap.Ground = level.get_node("/root/MainController/Level/" + LayerDefs.Ground)
	tilemap.IrradiatedGround = level.get_node("/root/MainController/Level/" + LayerDefs.IrradiatedGround)
	tilemap.Foreground = level.get_node("/root/MainController/Level/" + LayerDefs.Foreground)
	tilemap.Selection = level.get_node("/root/MainController/Level/" + LayerDefs.Selection)
	
	# Set up controllers
	welwalaController = SceneDefs.WelwalaController.instantiate()
	weaponController = SceneDefs.WeaponController.instantiate()
	playerController = SceneDefs.PlayerController.instantiate()
	playerController.weaponController = weaponController
	cameraController = SceneDefs.CameraController.instantiate()
	fireController = SceneDefs.FireController.instantiate()
	selectorController = SceneDefs.SelectorController.instantiate()
	add_child(welwalaController)	
	add_child(weaponController)
	add_child(playerController)
	add_child(cameraController)
	add_child(fireController)
	add_child(selectorController)
	
	HandOutTileMapLayers()
	HandOutControllers()
	
	mainUI = SceneDefs.mainUI.instantiate()
	add_child(mainUI)
	
	# Turn off the mouse cursor when inside the window
	# Eventually this will need to be turned back on when hovering over
	# UI panels/elements, but this is better for now
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
 
# A variety of controllers will need the tilemap layers, and that behaviour will 
# need repeated every time a level is loaded. This function will handle that.
func HandOutTileMapLayers() -> void:
	welwalaController.tilemap = tilemap
	weaponController.tilemap = tilemap
	fireController.tilemap = tilemap
	selectorController.tilemap = tilemap

func HandOutControllers() -> void:
	weaponController.selectorController = selectorController
