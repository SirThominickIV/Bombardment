extends Node
class_name UIController

var playerController
@export var weaponPanel: Control
@export var standardArtillery: Control
@export var incendiary: Control
@export var rodsFromTheGods: Control
@export var nuke: Control
@export var basicButtonSound: AudioStreamPlayer2D
@export var HealthLabel: Label
@export var ZoomAnimationPlayer: AnimationPlayer
@export var activeGameUiItems: Panel
@export var finishedGameUiItems: Panel
@export var finishedGameOutputHeader: Label
@export var finishedGameOutputBody: RichTextLabel

var zoomIn = false
const selected = Color("ffffff")
const deselected = Color("787878")

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	DisplayServer.window_set_min_size(Vector2(1000, 500))
	selectButton(standardArtillery)

func _process(_delta):	
	# Double checking shortcut keys
	#  - When the weapons panel is closed, the button shortcuts stop working
	if(Input.is_key_pressed(KEY_CTRL) || Input.is_key_pressed(KEY_SHIFT)):
		return
	if(Input.is_action_just_pressed("1")):	
		playerController.selectedProjectile = ProjectileDefs.StandardArtillery
		basicButtonSound.play()
	if(Input.is_action_just_pressed("2")):	
		playerController.selectedProjectile = ProjectileDefs.Incendiary
		basicButtonSound.play()
	if(Input.is_action_just_pressed("3")):	
		playerController.selectedProjectile = ProjectileDefs.RodsFromTheGods
		basicButtonSound.play()
	if(Input.is_action_just_pressed("4")):	
		playerController.selectedProjectile = ProjectileDefs.Nuke
		basicButtonSound.play()
		
	if(Input.is_action_just_pressed("9")):
		setHealthDisplay(1)

func zoom() -> void:
	zoomIn = !zoomIn
	if(zoomIn):
		ZoomAnimationPlayer.play('zoom')
		await get_tree().create_timer(5.0).timeout
		activeGameUiItems.visible = true
	else:
		activeGameUiItems.visible = false
		await get_tree().create_timer(1.0).timeout
		ZoomAnimationPlayer.play_backwards('zoom')

func showFinishedGame(gameWon: bool, outputBody: String) -> void:
	if(gameWon):
		finishedGameOutputHeader.text = 'VICTORY'
	else:
		finishedGameOutputHeader.text = 'DEFEAT'
	finishedGameOutputBody.text = outputBody
	finishedGameUiItems.visible = true
	
func hideFinishedGame() -> void:
	finishedGameUiItems.visible = false

func setHealthDisplay(numHealth: int) -> void:
	HealthLabel.text = ""
	for i in range(0, numHealth):
		HealthLabel.text += "◼"

func UI_Entered() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	playerController.isMouseOverUI = true

func UI_Exited() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	playerController.isMouseOverUI = false

func setWeaponStandardArtillery() -> void:
	playerController.selectedProjectile = ProjectileDefs.StandardArtillery
	selectButton(standardArtillery)
	basicButtonSound.play()

func setWeaponIncendiary() -> void:
	playerController.selectedProjectile = ProjectileDefs.Incendiary
	selectButton(incendiary)
	basicButtonSound.play()

func setWeaponRodsFromTheGods() -> void:
	playerController.selectedProjectile = ProjectileDefs.RodsFromTheGods
	selectButton(rodsFromTheGods)
	basicButtonSound.play()

func setWeaponNuke() -> void:
	playerController.selectedProjectile = ProjectileDefs.Nuke
	selectButton(nuke)
	basicButtonSound.play()

func selectButton(buttonElements: Control) -> void:
	standardArtillery.modulate = deselected
	incendiary.modulate = deselected
	rodsFromTheGods.modulate = deselected
	nuke.modulate = deselected
	buttonElements.modulate = selected

func toggleWeaponsPanel() -> void:
	weaponPanel.visible = !weaponPanel.visible
	basicButtonSound.play()
