extends Camera2D

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

func _ready():
	zoomTarget = zoom

func _physics_process(delta):	
	GetMoveSpeedForZoomlevel()
	Zoom()
	SimplePan()
	#ClickAndDrag()
	CheckPositionLimits()

func GetMoveSpeedForZoomlevel():
	# Take the zoom level, and put it through this equation. 
	# This will keep zoom slow when zoomed in and fast when zoomed out.
	# I recomend plugging this equation into desmos graphing if this
	# needs edited in the future.
	moveSpeedForZoomLevel = (1/zoom.x - 0.2) + 1

func Zoom():
	# Find the target zoom
	if(Input.is_action_just_pressed("ms_scroll_up")):
		zoomTarget *= 1.1
	if(Input.is_action_just_pressed("ms_scroll_down")):
		zoomTarget *= 0.9
		
	# Limit zooming
	if(zoomTarget > ZoomInLimit):
		zoomTarget = ZoomInLimit
	if(zoomTarget < ZoomOutLimit):
		zoomTarget = ZoomOutLimit
		
	# Zoooom
	zoom = zoom.slerp(zoomTarget, ZoomSpeed)

func SimplePan():

	
	if(Input.is_action_pressed("right")):
		position.x += MoveSpeed * moveSpeedForZoomLevel
	if(Input.is_action_pressed("left")):
		position.x += -MoveSpeed * moveSpeedForZoomLevel
		
	if(Input.is_action_pressed("up")):
		position.y += -MoveSpeed * moveSpeedForZoomLevel
	if(Input.is_action_pressed("down")):
		position.y += MoveSpeed * moveSpeedForZoomLevel

func ClickAndDrag():
	
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

func CheckPositionLimits():
	if(position.x < PositionLimitOne.x):
		position.x = PositionLimitOne.x
	if(position.y < PositionLimitOne.y):
		position.y = PositionLimitOne.y
	if(position.x > PositionLimitTwo.x):
		position.x = PositionLimitTwo.x
	if(position.y > PositionLimitTwo.y):
		position.y = PositionLimitTwo.y
