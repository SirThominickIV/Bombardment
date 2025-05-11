extends Node2D
class_name MainController

var level: Node

var controllers : Dictionary

var IsGameActive: bool = false

var currentLevel: int = 0

func _ready():

	# Gather the controllers
	controllers[ControllerDefs.Controllers.CameraController] = get_node("CameraController")
	controllers[ControllerDefs.Controllers.FireController] = get_node("FireController")
	controllers[ControllerDefs.Controllers.PlayerController] = get_node("PlayerController")
	controllers[ControllerDefs.Controllers.SelectorController] = get_node("SelectorController")
	controllers[ControllerDefs.Controllers.UIController] = get_node("UIController")
	controllers[ControllerDefs.Controllers.WeaponController] = get_node("WeaponController")
	controllers[ControllerDefs.Controllers.EnemyController] = get_node("EnemyController")
	controllers[ControllerDefs.Controllers.TileMapController] = get_node("TilemapController")
	
	_handOutControllers()
	
	StartGame(0)

func StartGame(levelIndex: int) -> void:
	if(levelIndex < 0):
		levelIndex = currentLevel
	
	
	controllers[ControllerDefs.Controllers.UIController].hideFinishedGame()
	await get_tree().create_timer(0.5).timeout
	level = SceneDefs.Levels[levelIndex].instantiate()
	add_child(level)
	
	# Combine tile map layers
	var tilemap = controllers[ControllerDefs.Controllers.TileMapController]
	tilemap.DestroyedTiles = level.get_node("/root/MainController/Level/" + LayerDefs.DestroyedTiles)
	tilemap.Ground = level.get_node("/root/MainController/Level/" + LayerDefs.Ground)
	tilemap.IrradiatedGround = level.get_node("/root/MainController/Level/" + LayerDefs.IrradiatedGround)
	tilemap.Foreground = level.get_node("/root/MainController/Level/" + LayerDefs.Foreground)
	tilemap.Selection = level.get_node("/root/MainController/Level/" + LayerDefs.Selection)
	
	controllers[ControllerDefs.Controllers.UIController].zoom()
	controllers[ControllerDefs.Controllers.CameraController].SwitchToGameStartPosition()
	await get_tree().create_timer(5.0).timeout
	IsGameActive = true
	
	_resetControllers()
 
func EndGame(gameWon: bool) -> void:
	
	# State handling
	if(!IsGameActive):
		return
	IsGameActive = false
	
	# Animation
	controllers[ControllerDefs.Controllers.UIController].zoom()
	controllers[ControllerDefs.Controllers.CameraController].SwitchToGameEndPosition()
	await get_tree().create_timer(5.0).timeout
	level.queue_free()
	await get_tree().create_timer(1.0).timeout
	
	# UI handling
	controllers[ControllerDefs.Controllers.UIController].showFinishedGame(gameWon, "placeholder")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _handOutControllers() -> void:
	
	# Sending out the TilemapController
	var tilemap = controllers[ControllerDefs.Controllers.TileMapController]
	controllers[ControllerDefs.Controllers.EnemyController].tilemap = tilemap
	controllers[ControllerDefs.Controllers.FireController].tilemap = tilemap
	controllers[ControllerDefs.Controllers.SelectorController].tilemap = tilemap
	
	# WeaponController reqs
	controllers[ControllerDefs.Controllers.WeaponController].tilemap = tilemap
	controllers[ControllerDefs.Controllers.WeaponController].selectorController = controllers[ControllerDefs.Controllers.SelectorController]
	controllers[ControllerDefs.Controllers.WeaponController].enemyController = controllers[ControllerDefs.Controllers.EnemyController]
	controllers[ControllerDefs.Controllers.WeaponController].uiController = controllers[ControllerDefs.Controllers.UIController]
	
	# UIController reqs
	controllers[ControllerDefs.Controllers.UIController].playerController = controllers[ControllerDefs.Controllers.PlayerController]
	
	# PlayerController reqs
	controllers[ControllerDefs.Controllers.PlayerController].weaponController = controllers[ControllerDefs.Controllers.WeaponController]
	controllers[ControllerDefs.Controllers.PlayerController].uiController = controllers[ControllerDefs.Controllers.UIController]
	controllers[ControllerDefs.Controllers.PlayerController].cameraController = controllers[ControllerDefs.Controllers.CameraController]
	
	# TilemapController reqs
	controllers[ControllerDefs.Controllers.TileMapController].enemyController = controllers[ControllerDefs.Controllers.EnemyController]

func GetController(controller) -> Node:
	return controllers[controller]

func _resetControllers() -> void:
	controllers[ControllerDefs.Controllers.FireController].reset()
	controllers[ControllerDefs.Controllers.PlayerController].reset()
	controllers[ControllerDefs.Controllers.EnemyController].reset()
	controllers[ControllerDefs.Controllers.WeaponController].reset()
