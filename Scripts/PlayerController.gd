extends Node
class_name PlayerController

var tilemap
var weaponController: WeaponController
var uiController: UIController
var cameraController: CameraController

var selectedProjectile = ProjectileDefs.StandardArtillery
var isMouseOverUI: bool = false
var _playerHealth: int = PlayerStatsDefs.PlayerHealth

@export var hullDamageSound: AudioStreamPlayer2D

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _process(_delta):
	if(!mainController.IsGameActive):
		return
	
	if(Input.is_action_just_pressed("k")):
		setPlayerHealth(-200)
	if(Input.is_action_pressed("mb_left") && !isMouseOverUI):	
		weaponController.spawnProjectile(selectedProjectile)

func reset() -> void:
	_playerHealth = PlayerStatsDefs.PlayerHealth

func setPlayerHealth(delta: int) -> void:
	# Apply delta and check limits
	_playerHealth = _playerHealth + delta
	if(_playerHealth > PlayerStatsDefs.PlayerHealth):
		_playerHealth = PlayerStatsDefs.PlayerHealth
	if(_playerHealth <= 0):
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_parent().EndGame(false)
	
	# If health is being removed, do camera shake and player damage noises
	if(delta < 0):
		cameraController.shake()
		hullDamageSound.play()
	
	# Update display if needed
	uiController.setHealthDisplay(_playerHealth)
	
