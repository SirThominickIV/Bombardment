extends RigidBody2D
class_name RocketHandler

@export var animatedSpriteSheet : AnimatedSprite2D

var ticks = 0
const launch_at_tick = 500
const safe_at_tick = 520
const do_damage_at_tick = 600

var is_launched = false
var tower_coords: Vector2i
var random = RandomNumberGenerator.new()

@onready var mainController: MainController = get_node('/root/MainController') as MainController
@onready var tilemap: TilemapController # Assigned from parent EnemyController when instantiated

func _physics_process(_delta):
	if(!mainController.is_game_active):
		return
	
	ticks += 1
	
	check_tower_status()
	
	if(ticks > launch_at_tick && !is_launched):
		is_launched = true
		launch()
	
	if(ticks > do_damage_at_tick):
		detonate()

func check_tower_status() -> void:
	# If the launch tower is intact, do nothing
	if(tilemap.Foreground.get_cell_source_id(tower_coords) == TileDefs.Tile.LaunchTower):
		return
	
	# If the rocket is far away (enough ticks) from the tower, do nothing
	if(ticks > safe_at_tick):
		return
	
	detonate()

func launch() -> void:
	gravity_scale = -0.5
	animatedSpriteSheet.play()

func detonate() -> void:
	# Do damage if the rocket surpased do_damage_at_tick
	if(ticks > do_damage_at_tick):
		get_tree().root.get_node("MainController").get_controller(ControllerDefs.Controllers.PlayerController) \
			.set_player_health(-random.randi_range(EnemyStatsDefs.EnemyRocketMinDamage,EnemyStatsDefs.EnemyRocketMaxDamage))
	
	# Tell the parent that the launch tower is free
	get_parent().remove_rocket(tower_coords)
	
	# Self destruct
	queue_free()
