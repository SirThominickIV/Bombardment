extends Node
class_name SelectorController

var selectedTile = Vector2(0, 0)

var tilemap : ExtendedTilemap = ExtendedTilemap.new()

func _process(delta):
	if(!Input.is_action_pressed("mb_right")):
		HandleSelector()

func HandleSelector():
	# Unselect the previous frames selection
	tilemap.Selection.erase_cell(selectedTile)
	
	print(selectedTile)
	
	# Grab the selected tile again
	var mousePos : Vector2 = tilemap.Selection.get_global_mouse_position()
	selectedTile = tilemap.Selection.local_to_map(mousePos)
	
	# Set the selector icon to the selected tile
	tilemap.Selection.set_cell(selectedTile, TileDefs.Selector, Vector2(0, 0))
