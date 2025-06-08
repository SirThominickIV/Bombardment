extends Node
class_name PlayerController

var tilemap
var weaponController: WeaponController
var uiController: UIController
var cameraController: CameraController

var selected_projectile = ProjectileDefs.StandardArtillery
var is_mouse_over_ui: bool = false
var _player_health: int = PlayerStatsDefs.PlayerHealth

@export var hullDamageSound: AudioStreamPlayer2D

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _process(_delta):
	if(!mainController.is_game_active):
		return
	
	if(Input.is_action_just_pressed("k")):
		set_player_health(-200)
	if(Input.is_action_pressed("mb_left") && !is_mouse_over_ui):
		weaponController.spawn_projectile(selected_projectile)

func reset() -> void:
	_player_health = PlayerStatsDefs.PlayerHealth
	uiController.set_health_display(_player_health)

func set_player_health(delta: int) -> void:
	# Apply delta and check limits
	_player_health = _player_health + delta
	if(_player_health > PlayerStatsDefs.PlayerHealth):
		_player_health = PlayerStatsDefs.PlayerHealth
	if(_player_health <= 0):
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_parent().end_game(false)
	
	# If health is being removed, do camera shake and player damage noises
	if(delta < 0):
		cameraController.shake()
		hullDamageSound.play()
	
	# Update display if needed
	uiController.set_health_display(_player_health)
	
