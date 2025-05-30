extends Node
class_name UIController

var playerController

# Weapons
@export var weaponPanel: Control
@export var standardArtillery: Control
@export var standardArtilleryLabel: Label
@export var incendiary: Control
@export var incendiaryLabel: Label
@export var rodsFromTheGods: Control
@export var rodsFromTheGodsLabel: Label
@export var nuke: Control
@export var nukeLabel: Label

# Other
@export var basicButtonSound: AudioStreamPlayer2D
@export var HealthBar: ColorRect
@export var ZoomAnimationPlayer: AnimationPlayer
@export var activeGameUiItems: Panel

# Game end
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
		playerController.selected_projectile = ProjectileDefs.StandardArtillery
		basicButtonSound.play()
	if(Input.is_action_just_pressed("2")):	
		playerController.selected_projectile = ProjectileDefs.Incendiary
		basicButtonSound.play()
	if(Input.is_action_just_pressed("3")):	
		playerController.selected_projectile = ProjectileDefs.RodsFromTheGods
		basicButtonSound.play()
	if(Input.is_action_just_pressed("4")):	
		playerController.selected_projectile = ProjectileDefs.Nuke
		basicButtonSound.play()
		
	if(Input.is_action_just_pressed("9")):
		setHealthDisplay(1)

func reset() -> void:
	setHealthDisplay(20)

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

func showFinishedGame(gameWon: bool) -> void:
	if(gameWon):
		finishedGameOutputHeader.text = 'VICTORY'
	else:
		finishedGameOutputHeader.text = 'DEFEAT'
	finishedGameOutputBody.text = "outputBody"
	finishedGameUiItems.visible = true
	
func hideFinishedGame() -> void:
	finishedGameUiItems.visible = false

func setHealthDisplay(numHealth: int) -> void:
	if(numHealth < 0):
		numHealth = 0
	if(numHealth > PlayerStatsDefs.PlayerHealth):
		numHealth = PlayerStatsDefs.PlayerHealth
	HealthBar.scale.x = numHealth/(PlayerStatsDefs.PlayerHealth * 1.0)

func set_artillery_label(s: String) -> void:
	standardArtilleryLabel.text = s

func set_incendiary_label(s: String) -> void:
	incendiaryLabel.text = s

func set_rodsfromthegods_label(s: String) -> void:
	rodsFromTheGodsLabel.text = s

func set_nuke_label(s: String) -> void:
	nukeLabel.text = s

func UI_Entered() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	playerController.is_mouse_over_ui = true

func UI_Exited() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	playerController.is_mouse_over_ui = false

func setWeaponStandardArtillery() -> void:
	playerController.selected_projectile = ProjectileDefs.StandardArtillery
	selectButton(standardArtillery)
	basicButtonSound.play()

func setWeaponIncendiary() -> void:
	playerController.selected_projectile = ProjectileDefs.Incendiary
	selectButton(incendiary)
	basicButtonSound.play()

func setWeaponRodsFromTheGods() -> void:
	playerController.selected_projectile = ProjectileDefs.RodsFromTheGods
	selectButton(rodsFromTheGods)
	basicButtonSound.play()

func setWeaponNuke() -> void:
	playerController.selected_projectile = ProjectileDefs.Nuke
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
