extends Node2D
class_name MainController

var level

var controllers : Dictionary

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
	
	# Gather the controllers
	controllers[ControllerDefs.CameraController] = get_node("CameraController")
	controllers[ControllerDefs.FireController] = get_node("FireController")
	controllers[ControllerDefs.PlayerController] = get_node("PlayerController")
	controllers[ControllerDefs.SelectorController] = get_node("SelectorController")
	controllers[ControllerDefs.UIController] = get_node("UIController")
	controllers[ControllerDefs.WeaponController] = get_node("WeaponController")
	controllers[ControllerDefs.WelwalaController] = get_node("WelwalaController")
	
	HandOutTileMapLayers()
	HandOutControllers()
 
# A variety of controllers will need the tilemap layers, and that behaviour will 
# need repeated every time a level is loaded. This function will handle that.
func HandOutTileMapLayers() -> void:
	controllers[ControllerDefs.WelwalaController].tilemap = tilemap
	controllers[ControllerDefs.WeaponController].tilemap = tilemap
	controllers[ControllerDefs.FireController].tilemap = tilemap
	controllers[ControllerDefs.SelectorController].tilemap = tilemap

func HandOutControllers() -> void:
	controllers[ControllerDefs.WeaponController].selectorController = controllers[ControllerDefs.SelectorController]
	controllers[ControllerDefs.UIController].playerController = controllers[ControllerDefs.PlayerController]
	
	controllers[ControllerDefs.PlayerController].weaponController = controllers[ControllerDefs.WeaponController]
	controllers[ControllerDefs.PlayerController].uiController = controllers[ControllerDefs.UIController]
	controllers[ControllerDefs.PlayerController].cameraController = controllers[ControllerDefs.CameraController]

func GetController(controller) -> Node:
	return controllers[controller]
