extends Node2D
class_name MainController

var level: Node

var controllers : Dictionary

var tilemap : ExtendedTilemap = ExtendedTilemap.new()

var IsGameActive: bool = false

var currentLevel: int = 0

func _ready():

	# Gather the controllers
	controllers[ControllerDefs.CameraController] = get_node("CameraController")
	controllers[ControllerDefs.FireController] = get_node("FireController")
	controllers[ControllerDefs.PlayerController] = get_node("PlayerController")
	controllers[ControllerDefs.SelectorController] = get_node("SelectorController")
	controllers[ControllerDefs.UIController] = get_node("UIController")
	controllers[ControllerDefs.WeaponController] = get_node("WeaponController")
	controllers[ControllerDefs.WelwalaController] = get_node("WelwalaController")
	
	_handOutTileMapLayers()
	_handOutControllers()
	
	StartGame(0)

func StartGame(levelIndex: int) -> void:
	if(levelIndex < 0):
		levelIndex = currentLevel
	
	_resetControllers()
	
	controllers[ControllerDefs.UIController].hideFinishedGame()
	await get_tree().create_timer(0.5).timeout
	level = SceneDefs.Levels[levelIndex].instantiate()
	add_child(level)
	
	# Combine tile map layers
	tilemap.DestroyedTiles = level.get_node("/root/MainController/Level/" + LayerDefs.DestroyedTiles)
	tilemap.Ground = level.get_node("/root/MainController/Level/" + LayerDefs.Ground)
	tilemap.IrradiatedGround = level.get_node("/root/MainController/Level/" + LayerDefs.IrradiatedGround)
	tilemap.Foreground = level.get_node("/root/MainController/Level/" + LayerDefs.Foreground)
	tilemap.Selection = level.get_node("/root/MainController/Level/" + LayerDefs.Selection)
	
	controllers[ControllerDefs.UIController].zoom()
	controllers[ControllerDefs.CameraController].SwitchToGameStartPosition()
	await get_tree().create_timer(5.0).timeout
	IsGameActive = true
 
func EndGame(gameWon: bool) -> void:
	if(!IsGameActive):
		return
	IsGameActive = false
	
	controllers[ControllerDefs.UIController].zoom()
	controllers[ControllerDefs.CameraController].SwitchToGameEndPosition()
	await get_tree().create_timer(5.0).timeout
	level.queue_free()
	await get_tree().create_timer(1.0).timeout
	controllers[ControllerDefs.UIController].showFinishedGame(gameWon, "placeholder")

# A variety of controllers will need the tilemap layers, and that behaviour will 
# need repeated every time a level is loaded. This function will handle that.
func _handOutTileMapLayers() -> void:
	controllers[ControllerDefs.WelwalaController].tilemap = tilemap
	controllers[ControllerDefs.WeaponController].tilemap = tilemap
	controllers[ControllerDefs.FireController].tilemap = tilemap
	controllers[ControllerDefs.SelectorController].tilemap = tilemap

func _handOutControllers() -> void:
	controllers[ControllerDefs.WeaponController].selectorController = controllers[ControllerDefs.SelectorController]
	controllers[ControllerDefs.UIController].playerController = controllers[ControllerDefs.PlayerController]
	
	controllers[ControllerDefs.PlayerController].weaponController = controllers[ControllerDefs.WeaponController]
	controllers[ControllerDefs.PlayerController].uiController = controllers[ControllerDefs.UIController]
	controllers[ControllerDefs.PlayerController].cameraController = controllers[ControllerDefs.CameraController]

func GetController(controller) -> Node:
	return controllers[controller]

func _resetControllers() -> void:
	controllers[ControllerDefs.WelwalaController].reset()
	controllers[ControllerDefs.FireController].reset()
