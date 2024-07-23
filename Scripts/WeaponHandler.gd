extends "res://Scripts/TilemapExtensions.gd"

var selectedTile = Vector2(0, 0)
var random = RandomNumberGenerator.new()

# Using physics processing to keep deletion consistent
func _physics_process(delta):
	
	# Unselect the previous frames selection
	erase_cell(LayerDefs.Selection, selectedTile)
	
	# Grab the selected tile again
	var mousePos : Vector2 = get_global_mouse_position()
	selectedTile = local_to_map(mousePos)
	
	# Set the selector icon to the selected tile
	set_cell(LayerDefs.Selection, selectedTile, TileDefs.Selector, Vector2(0, 0))
	
	# Process the destruction of tile(s) if needed
	if(Input.is_action_just_pressed("mb_left")):	
		doStandardArtillery()
		
	# Debug - Restore buildings on right click
	if(Input.is_action_just_pressed("mb_right")):
		var usedCells = get_used_cells(LayerDefs.DestroyedTiles)
		for cell in usedCells:
			moveTileToLayer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, cell, null, null)

func doStandardArtillery():	
	# Godot has a built in get_neighbor_cell function, but it has a weird
	# enum that is uses to find the neighbors, and it doesn't quite work right.
	# so this is silly but better than outright failing
	
	# Erase two random nearby cells
	var relativeCoords = selectedTile;
	relativeCoords.x = selectedTile.x + random.randi_range(-1, 1)
	relativeCoords.y = selectedTile.y + random.randi_range(-1, 1)
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	relativeCoords.x = selectedTile.x + random.randi_range(-1, 1)
	relativeCoords.y = selectedTile.y + random.randi_range(-1, 1)
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	
	# Erase the selected one
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, selectedTile, TileDefs.Debris, LayerDefs.Foreground)	

func doNuke():	
		
	# Erase random nearby cells, replace with debris
	for i in range(13):
		var relativeCoords = selectedTile;
		relativeCoords.x = selectedTile.x + random.randi_range(-3, 3)
		relativeCoords.y = selectedTile.y + random.randi_range(-3, 3)
		moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	
	# Set a number of cells to irradiated tiles
	for i in range(13):
		var relativeCoords = selectedTile;
		relativeCoords.x = selectedTile.x + random.randi_range(-2, 2)
		relativeCoords.y = selectedTile.y + random.randi_range(-2, 2)
		moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)
		#erase_cell(LayerDefs.Foreground, relativeCoords)
		#set_cell(LayerDefs.IrradiatedGround, relativeCoords, TileDefs.IrradiatedEarth, Vector2(0, 0))
	
	# Set the selected
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, selectedTile, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)
		


