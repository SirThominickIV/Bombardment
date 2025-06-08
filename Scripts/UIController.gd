extends Node
class_name UIController

var playerController: PlayerController
var enemyController: EnemyController

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
	select_button(standardArtillery)

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
		set_health_display(1)

func reset() -> void:
	set_health_display(20)

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

func show_finished_game(gameWon: bool) -> void:
	if(gameWon):
		finishedGameOutputHeader.text = '[MSGPYLD: VICTORY]'
		finishedGameOutputBody.text = "100% of population exterminated\n\n[/MSGPYLD]"
	else:
		finishedGameOutputHeader.text = '[MSGPYLD: VICTORY]'
		var ammount = int((1-(float(len(enemyController.civilians))/float(enemyController.civilian_count_at_start)))*100)
		finishedGameOutputBody.text = str(ammount) + "% of population exterminated\n\n[/MSGPYLD]"
	finishedGameUiItems.visible = true
	
func hide_finished_game() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	finishedGameUiItems.visible = false

func set_health_display(numHealth: int) -> void:
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

func ui_entered() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	playerController.is_mouse_over_ui = true

func ui_exited() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	playerController.is_mouse_over_ui = false

func set_count_standard_artillery() -> void:
	playerController.selected_projectile = ProjectileDefs.StandardArtillery
	select_button(standardArtillery)
	basicButtonSound.play()

func set_count_incendiary() -> void:
	playerController.selected_projectile = ProjectileDefs.Incendiary
	select_button(incendiary)
	basicButtonSound.play()

func set_count_rods_from_the_gods() -> void:
	playerController.selected_projectile = ProjectileDefs.RodsFromTheGods
	select_button(rodsFromTheGods)
	basicButtonSound.play()

func set_count_nuke() -> void:
	playerController.selected_projectile = ProjectileDefs.Nuke
	select_button(nuke)
	basicButtonSound.play()

func select_button(buttonElements: Control) -> void:
	standardArtillery.modulate = deselected
	incendiary.modulate = deselected
	rodsFromTheGods.modulate = deselected
	nuke.modulate = deselected
	buttonElements.modulate = selected

func toggle_weapons_panel() -> void:
	weaponPanel.visible = !weaponPanel.visible
	basicButtonSound.play()
