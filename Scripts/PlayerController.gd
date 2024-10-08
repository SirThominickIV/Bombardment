extends Node
class_name PlayerController

var tilemap
var weaponController: WeaponController
var uiController: UIController
var cameraController: CameraController

var selectedProjectile = ProjectileDefs.StandardArtillery
var isMouseOverUI: bool = false
var _playerHealth: int = 20

@export var hullDamageSound: AudioStreamPlayer2D

func _process(delta):
	if(Input.is_action_just_pressed("k")):
		print("Player Ended the game")
		setPlayerHealth(-200)
	if(Input.is_action_just_pressed("mb_left") && !isMouseOverUI):	
		weaponController.spawnProjectile(selectedProjectile)

func setPlayerHealth(delta: int) -> void:
	# Apply delta and check limits
	_playerHealth = _playerHealth + delta
	if(_playerHealth > 20):
		_playerHealth = 20
	if(_playerHealth <= 0):
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_parent().EndGame(false)
	
	# If health is being removed, do camera shake and player damage noises
	if(delta < 0):
		cameraController.shake()
		hullDamageSound.play()
	
	# Update display if needed
	uiController.setHealthDisplay(_playerHealth)
	
