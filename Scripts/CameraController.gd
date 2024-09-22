extends Camera2D
class_name CameraController

@onready var mainController: MainController = get_node('/root/MainController') as MainController

#### Normal camera movement ####
@export var ZoomSpeed = 1.0
@export var ZoomOutLimit = Vector2(1, 1)
@export var ZoomInLimit = Vector2(3.0, 3.0)
@export var MoveSpeed = 10

@export var PositionLimitOne = Vector2(0,0)
@export var PositionLimitTwo = Vector2(2000, 1000)

var zoomTarget : Vector2
var moveSpeedForZoomLevel = 1.0

var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

#### Camera shake ####
# Camera shake code thanks to The Shaggy Dev 
# https://shaggydev.com/2022/02/23/screen-shake-godot/
# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 5.0

@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
var shake_strength: float = 0.0

#### Planet level zoomIn/out ####
const zoomTargetForActiveGame = Vector2(1, 1)
const zoomTargetForInactiveGame = Vector2(0.01, 0.01)

func _ready():
	zoomTarget = zoom
	
	# Camera shake stuff
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2.0

func _process(delta):
	if(!mainController.IsGameActive):
		return
		
	_GetMoveSpeedForZoomlevel()
	_PlayerInputZoom()
	_SimplePan()
	_ClickAndDrag()
	#_CheckPositionLimits()

func _physics_process(delta):
	# Camera shake
	# Fade out the intensity over time
	if(shake_strength > 0):
		shake_strength = shake_strength - SHAKE_DECAY_RATE * delta
		if (shake_strength < 0):
			shake_strength = 0
	
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = _get_noise_offset(delta)
	
	# Zoooom
	if(mainController.IsGameActive):
		zoom = zoom.slerp(zoomTarget, ZoomSpeed) # Responsive, quick zoom for player
	else:
		zoom = zoom.slerp(zoomTarget, delta) # Gradual zoom for animation
	print(zoom)

func SwitchToGameStartPosition():
	await get_tree().create_timer(1.0).timeout
	print("SwitchToGameStartPosition")
	zoomTarget = zoomTargetForActiveGame

func SwitchToGameEndPosition():
	await get_tree().create_timer(1.0).timeout
	print("SwitchToGameEndPosition")
	zoomTarget = zoomTargetForInactiveGame


func shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

func _GetMoveSpeedForZoomlevel():
	# Take the zoom level, and put it through this equation. 
	# This will keep zoom slow when zoomed in and fast when zoomed out.
	# I recomend plugging this equation into desmos graphing if this
	# needs edited in the future.
	moveSpeedForZoomLevel = (1/zoom.x - 0.2) + 1

func _PlayerInputZoom():
	# Find the target zoom
	if(Input.is_action_just_pressed("ms_scroll_up")):
		zoomTarget *= 1.1
	if(Input.is_action_just_pressed("ms_scroll_down")):
		zoomTarget *= 0.9
		
	# Limit zooming
	#if(zoomTarget > ZoomInLimit):
		#zoomTarget = ZoomInLimit
	#if(zoomTarget < ZoomOutLimit):
		#zoomTarget = ZoomOutLimit

func _SimplePan():	
	if(Input.is_action_pressed("right")):
		position.x += MoveSpeed * moveSpeedForZoomLevel
	if(Input.is_action_pressed("left")):
		position.x += -MoveSpeed * moveSpeedForZoomLevel
		
	if(Input.is_action_pressed("up")):
		position.y += -MoveSpeed * moveSpeedForZoomLevel
	if(Input.is_action_pressed("down")):
		position.y += MoveSpeed * moveSpeedForZoomLevel

func _ClickAndDrag():
	
	# Check if starting to drag
	if (!isDragging and Input.is_action_just_pressed("mb_right")):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	# Check if stopping drag
	else: if (isDragging and Input.is_action_just_released("mb_right")):
		isDragging = false
		
	# Do drag if needed
	else: if (isDragging):
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * moveSpeedForZoomLevel

func _CheckPositionLimits():
	if(position.x < PositionLimitOne.x):
		position.x = PositionLimitOne.x
	if(position.y < PositionLimitOne.y):
		position.y = PositionLimitOne.y
	if(position.x > PositionLimitTwo.x):
		position.x = PositionLimitTwo.x
	if(position.y > PositionLimitTwo.y):
		position.y = PositionLimitTwo.y

func _get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
