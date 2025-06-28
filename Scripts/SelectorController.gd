extends Node
class_name SelectorController

var selectedTile = Vector2i(0, 0)

var tilemap: TilemapController

@onready var mainController: MainController = get_parent() as MainController

var targetedTiles: Array[Vector2i] = []

func _process(_delta):
	
	if(!mainController.is_game_active):
		return
	
	if(!Input.is_action_pressed("mb_right")):
		handle_selector()

func add_targeted_tile(tile: Vector2i) -> void:
	targetedTiles.append(tile)
	tilemap.Selection.set_cell(tile, TileDefs.Tile.Selector, Vector2(0, 1))

func remove_targeted_tile(tile: Vector2i) -> void:
	var index = targetedTiles.find(tile)
	targetedTiles.remove_at(index)
	
	# Check if the tile is still targeted (there may be >1 projectile)
	if not tile in targetedTiles:
		tilemap.Selection.erase_cell(tile)

func handle_selector() -> void:
	
	# Grab the selected tile
	var mousePos : Vector2 = tilemap.Selection.get_global_mouse_position()
	var newSelectedTile = tilemap.Selection.local_to_map(mousePos)
	
	# Skip if the tile is already targeted
	if newSelectedTile in targetedTiles:
		return
	
	# Unselect the previous frames selection if it wasn't one of the targeted ones
	if not selectedTile in targetedTiles:
		tilemap.Selection.erase_cell(selectedTile)
	
	# Updated
	selectedTile = newSelectedTile
	
	# Set the selector icon to the selected tile
	tilemap.Selection.set_cell(selectedTile, TileDefs.Tile.Selector, Vector2(0, 0))
