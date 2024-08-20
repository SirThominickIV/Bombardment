extends "res://Scripts/TilemapExtensions.gd"

var selectedTile = Vector2(0, 0)

func _process(delta):
	if(!Input.is_action_pressed("mb_right")):
		HandleSelector()

func HandleSelector():
	# Unselect the previous frames selection
	erase_cell(LayerDefs.Selection, selectedTile)
	
	# Grab the selected tile again
	var mousePos : Vector2 = get_global_mouse_position()
	selectedTile = local_to_map(mousePos)
	
	# Set the selector icon to the selected tile
	set_cell(LayerDefs.Selection, selectedTile, TileDefs.Selector, Vector2(0, 0))
