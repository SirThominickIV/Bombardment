extends Camera2D
class_name CameraController

@onready var mainController: MainController = get_node('/root/MainController') as MainController

#### Normal camera movement ####
@export var zoom_speed = 1.0
@export var zoom_out_limit = Vector2(1, 1)
@export var zoom_in_limit = Vector2(3.0, 3.0)
@export var move_speed = 10

@export var position_limit_one = Vector2(0,0)
@export var position_limit_two = Vector2(2000, 1000)

var zoom_target : Vector2
var move_speed_for_zoom_level = 1.0

var drag_start_mouse_pos = Vector2.ZERO
var drag_start_camera_pos = Vector2.ZERO
var is_dragging : bool = false

#### Camera shake ####
# Camera shake code thanks to The Shaggy Dev 
# https://shaggydev.com/2022/02/23/screen-shake-godot/
# How quickly to move through the noise
@export var noise_shake_speed: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var noise_shake_strength: float = 60.0
# Multiplier for lerping the shake strength to zero
@export var shake_decay_rate: float = 5.0

@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
var shake_strength: float = 0.0

#### Planet level zoomIn/out ####
const zoom_target_for_active_game = Vector2(1, 1)
const zoom_target_for_inactive_game = Vector2(0.01, 0.01)

func _ready():
	zoom_target = zoom
	
	# Camera shake stuff
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2.0

func _process(_delta):
	if(!mainController.is_game_active):
		return
		
	_Getmove_speedForZoomlevel()
	_PlayerInputZoom()
	_SimplePan()
	_ClickAndDrag()
	#_CheckPositionLimits()

func _physics_process(delta):
	# Camera shake
	# Fade out the intensity over time
	if(shake_strength > 0):
		shake_strength = shake_strength - shake_decay_rate * delta
		if (shake_strength < 0):
			shake_strength = 0
	
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = _get_noise_offset(delta)
	
	# Zoooom
	if(mainController.is_game_active):
		zoom = zoom.slerp(zoom_target, zoom_speed) # Responsive, quick zoom for player
	else:
		zoom = zoom.slerp(zoom_target, delta) # Gradual zoom for animation

func SwitchToGameStartPosition():
	await get_tree().create_timer(1.0).timeout
	zoom_target = zoom_target_for_active_game

func SwitchToGameEndPosition():
	await get_tree().create_timer(1.0).timeout
	zoom_target = zoom_target_for_inactive_game

func shake() -> void:
	shake_strength = noise_shake_strength

func _Getmove_speedForZoomlevel():
	# Take the zoom level, and put it through this equation. 
	# This will keep zoom slow when zoomed in and fast when zoomed out.
	# I recomend plugging this equation into desmos graphing if this
	# needs edited in the future.
	move_speed_for_zoom_level = (1/zoom.x - 0.2) + 1

func _PlayerInputZoom():
	# Find the target zoom
	if(Input.is_action_just_pressed("ms_scroll_up")):
		zoom_target *= 1.1
	if(Input.is_action_just_pressed("ms_scroll_down")):
		zoom_target *= 0.9
		
	# Limit zooming
	#if(zoom_target > zoom_in_limit):
		#zoom_target = zoom_in_limit
	#if(zoom_target < zoom_out_limit):
		#zoom_target = zoom_out_limit

func _SimplePan():	
	if(Input.is_action_pressed("right")):
		position.x += move_speed * move_speed_for_zoom_level
	if(Input.is_action_pressed("left")):
		position.x += -move_speed * move_speed_for_zoom_level
		
	if(Input.is_action_pressed("up")):
		position.y += -move_speed * move_speed_for_zoom_level
	if(Input.is_action_pressed("down")):
		position.y += move_speed * move_speed_for_zoom_level

func _ClickAndDrag():
	
	# Check if starting to drag
	if (!is_dragging and Input.is_action_just_pressed("mb_right")):
		drag_start_mouse_pos = get_viewport().get_mouse_position()
		drag_start_camera_pos = position
		is_dragging = true
		
	# Check if stopping drag
	else: if (is_dragging and Input.is_action_just_released("mb_right")):
		is_dragging = false
		
	# Do drag if needed
	else: if (is_dragging):
		var moveVector = get_viewport().get_mouse_position() - drag_start_mouse_pos
		position = drag_start_camera_pos - moveVector * move_speed_for_zoom_level

func _CheckPositionLimits():
	if(position.x < position_limit_one.x):
		position.x = position_limit_one.x
	if(position.y < position_limit_one.y):
		position.y = position_limit_one.y
	if(position.x > position_limit_two.x):
		position.x = position_limit_two.x
	if(position.y > position_limit_two.y):
		position.y = position_limit_two.y

func _get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
