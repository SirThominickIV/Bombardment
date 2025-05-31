extends Node2D
class_name MainController

var level: Node

var controllers : Dictionary

var is_game_active: bool = false

var current_level: int = 0

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
	
	_hand_out_controllers()
	
	start_game()

func start_game(level_index: int = -1) -> void:
	if(level_index < 0):
		level_index = current_level
	
	controllers[ControllerDefs.Controllers.UIController].hideFinishedGame()
	await get_tree().create_timer(0.5).timeout
	level = SceneDefs.Levels[level_index].instantiate()
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
	is_game_active = true
	
	_reset_controllers()
 
func end_game(game_won: bool) -> void:
	
	# State handling
	if(!is_game_active):
		return
	is_game_active = false
	
	# Animation
	controllers[ControllerDefs.Controllers.UIController].zoom()
	controllers[ControllerDefs.Controllers.CameraController].SwitchToGameEndPosition()
	await get_tree().create_timer(5.0).timeout
	level.queue_free()
	await get_tree().create_timer(1.0).timeout
	
	# UI handling
	controllers[ControllerDefs.Controllers.UIController].showFinishedGame(game_won)
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

func _hand_out_controllers() -> void:
	
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
	controllers[ControllerDefs.Controllers.UIController].enemyController = controllers[ControllerDefs.Controllers.EnemyController]
	
	# PlayerController reqs
	controllers[ControllerDefs.Controllers.PlayerController].weaponController = controllers[ControllerDefs.Controllers.WeaponController]
	controllers[ControllerDefs.Controllers.PlayerController].uiController = controllers[ControllerDefs.Controllers.UIController]
	controllers[ControllerDefs.Controllers.PlayerController].cameraController = controllers[ControllerDefs.Controllers.CameraController]
	
	# TilemapController reqs
	controllers[ControllerDefs.Controllers.TileMapController].enemyController = controllers[ControllerDefs.Controllers.EnemyController]

func get_controller(controller) -> Node:
	return controllers[controller]

func _reset_controllers() -> void:
	controllers[ControllerDefs.Controllers.FireController].reset()
	controllers[ControllerDefs.Controllers.PlayerController].reset()
	controllers[ControllerDefs.Controllers.EnemyController].reset()
	controllers[ControllerDefs.Controllers.WeaponController].reset()
