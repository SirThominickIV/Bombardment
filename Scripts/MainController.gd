extends Node2D
class_name MainController

var level: Node

var controllers : Dictionary

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
	controllers[ControllerDefs.EnemyController] = get_node("EnemyController")
	controllers[ControllerDefs.TileMapController] = get_node("TilemapController")
	
	_handOutControllers()
	
	StartGame(0)

func StartGame(levelIndex: int) -> void:
	if(levelIndex < 0):
		levelIndex = currentLevel
	
	
	controllers[ControllerDefs.UIController].hideFinishedGame()
	await get_tree().create_timer(0.5).timeout
	level = SceneDefs.Levels[levelIndex].instantiate()
	add_child(level)
	
	# Combine tile map layers
	var tilemap = controllers[ControllerDefs.TileMapController]
	tilemap.DestroyedTiles = level.get_node("/root/MainController/Level/" + LayerDefs.DestroyedTiles)
	tilemap.Ground = level.get_node("/root/MainController/Level/" + LayerDefs.Ground)
	tilemap.IrradiatedGround = level.get_node("/root/MainController/Level/" + LayerDefs.IrradiatedGround)
	tilemap.Foreground = level.get_node("/root/MainController/Level/" + LayerDefs.Foreground)
	tilemap.Selection = level.get_node("/root/MainController/Level/" + LayerDefs.Selection)
	
	controllers[ControllerDefs.UIController].zoom()
	controllers[ControllerDefs.CameraController].SwitchToGameStartPosition()
	await get_tree().create_timer(5.0).timeout
	IsGameActive = true
	
	_resetControllers()
 
func EndGame(gameWon: bool) -> void:
	
	# State handling
	if(!IsGameActive):
		return
	IsGameActive = false
	
	# Animation
	controllers[ControllerDefs.UIController].zoom()
	controllers[ControllerDefs.CameraController].SwitchToGameEndPosition()
	await get_tree().create_timer(5.0).timeout
	level.queue_free()
	await get_tree().create_timer(1.0).timeout
	
	# UI handling
	controllers[ControllerDefs.UIController].showFinishedGame(gameWon, "placeholder")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _handOutControllers() -> void:
	
	# Sending out the TilemapController
	var tilemap = controllers[ControllerDefs.TileMapController]
	controllers[ControllerDefs.EnemyController].tilemap = tilemap
	controllers[ControllerDefs.FireController].tilemap = tilemap
	controllers[ControllerDefs.SelectorController].tilemap = tilemap
	
	# WeaponController reqs
	controllers[ControllerDefs.WeaponController].tilemap = tilemap
	controllers[ControllerDefs.WeaponController].selectorController = controllers[ControllerDefs.SelectorController]
	controllers[ControllerDefs.WeaponController].enemyController = controllers[ControllerDefs.EnemyController]
	
	# UIController reqs
	controllers[ControllerDefs.UIController].playerController = controllers[ControllerDefs.PlayerController]
	
	# PlayerController reqs
	controllers[ControllerDefs.PlayerController].weaponController = controllers[ControllerDefs.WeaponController]
	controllers[ControllerDefs.PlayerController].uiController = controllers[ControllerDefs.UIController]
	controllers[ControllerDefs.PlayerController].cameraController = controllers[ControllerDefs.CameraController]
	
	# TilemapController reqs
	controllers[ControllerDefs.TileMapController].enemyController = controllers[ControllerDefs.EnemyController]

func GetController(controller) -> Node:
	return controllers[controller]

func _resetControllers() -> void:
	controllers[ControllerDefs.FireController].reset()
	controllers[ControllerDefs.PlayerController].reset()
	controllers[ControllerDefs.EnemyController].reset()
