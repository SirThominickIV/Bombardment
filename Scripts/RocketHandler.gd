extends RigidBody2D

@export var animatedSpriteSheet : AnimatedSprite2D

var ticks = 0
const launchAtTick = 500
const detonateAtTick = 600
var isLaunched = false

func _process(delta):
	print(ticks)
	
	ticks += 1
	if(ticks > launchAtTick && !isLaunched):
		isLaunched = true
		launch()
	
	if(ticks > detonateAtTick):
		get_tree().root.get_node("MainController").GetController(ControllerDefs.PlayerController).setPlayerHealth(-1)
		queue_free()

func launch() -> void:
	gravity_scale = -0.5
	animatedSpriteSheet.play()
