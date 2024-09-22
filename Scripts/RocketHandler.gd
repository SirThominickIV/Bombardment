extends RigidBody2D
class_name RocketHandler

@export var animatedSpriteSheet : AnimatedSprite2D

var ticks = 0
const launchAtTick = 500
const safeAtTick = 520
const doDamageAtTick = 600

var isLaunched = false
var towerCoords: Vector2i
var tilemap: ExtendedTilemap
var random = RandomNumberGenerator.new()

const minDamage = 20
const maxDamage = 21

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _physics_process(delta):
	if(!mainController.IsGameActive):
		return
	
	ticks += 1
	
	CheckTowerStatus()
	
	if(ticks > launchAtTick && !isLaunched):
		isLaunched = true
		launch()
	
	if(ticks > doDamageAtTick):
		Detonate()

func CheckTowerStatus() -> void:
	# If the launch tower is intact, do nothing
	if(tilemap.Foreground.get_cell_source_id(towerCoords) == TileDefs.LaunchTower):
		return
	
	# If the rocket is far away (enough ticks) from the tower, do nothing
	if(ticks > safeAtTick):
		return
	
	Detonate()

func launch() -> void:
	gravity_scale = -0.5
	animatedSpriteSheet.play()

func Detonate() -> void:
	# Do damage if the rocket surpased doDamageAtTick
	if(ticks > doDamageAtTick):
		get_tree().root.get_node("MainController").GetController(ControllerDefs.PlayerController).setPlayerHealth(-random.randi_range(minDamage,maxDamage))
	
	# Tell the parent that the launch tower is free
	get_parent().RemoveRocket(towerCoords)
	
	# Self destruct
	queue_free()
