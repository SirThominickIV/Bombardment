extends Node
class_name PlayerController

var tilemap
var weaponController : WeaponController
var uiController : UIController

var selectedProjectile = ProjectileDefs.StandardArtillery
var isMouseOverUI: bool = false
var playerHealth: int = 20

func _process(delta):
	
	if(Input.is_action_just_pressed("mb_left") && !isMouseOverUI):	
		weaponController.spawnProjectile(selectedProjectile)
		setPlayerHealth(-1)

func setPlayerHealth(delta: int) -> void:
	playerHealth = playerHealth + delta
	if(playerHealth > 20):
		playerHealth = 20
	
	uiController.setHealthDisplay(playerHealth)
	
	if(playerHealth <= 0):
		get_tree().change_scene_to_file(SceneDefs.LostGame)
