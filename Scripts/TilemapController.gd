extends Node
class_name TilemapController

var DestroyedTiles : TileMapLayer = TileMapLayer.new()
var Ground : TileMapLayer = TileMapLayer.new()
var IrradiatedGround : TileMapLayer = TileMapLayer.new()
var Foreground : TileMapLayer = TileMapLayer.new()
var Selection : TileMapLayer = TileMapLayer.new()

var enemyController: EnemyController

var random = RandomNumberGenerator.new()

func destroy(coords: Vector2i, 
	type: ProjectileDefs.Destruction_Type = ProjectileDefs.Destruction_Type.Default, 
	is_direct: bool = false):
	
	# Find out what it is
	var sourceId = Foreground.get_cell_source_id(coords)
	var atlasCoords = Foreground.get_cell_atlas_coords(coords)
	
	# Guard against invulnerable tiles
	if(TileDefs.Invulnerable.has(sourceId)):
		return
	
	# Guard against tiles that have no land
	if(Ground.get_cell_source_id(coords) != TileDefs.Tile.Earth):
		return
	
	# Guard against resistant tiles
	if(TileDefs.Resistant.has(sourceId) && !is_direct):
		return
	
	# Do the destruction
	enemyController.kill_civilian(coords)
	Foreground.erase_cell(coords)
	
	match type:
		ProjectileDefs.Destruction_Type.Default:
			Foreground.set_cell(coords, TileDefs.Tile.Debris, Vector2(0,0))
		ProjectileDefs.Destruction_Type.Fire:
			Foreground.set_cell(coords, TileDefs.Tile.Fire, Vector2(0,0))
		ProjectileDefs.Destruction_Type.Irradiated:
			Foreground.set_cell(coords, TileDefs.Tile.IrradiatedEarth, Vector2(0,0))

# The get_surrounding_cells method is nice, but it doesn't get the corners
# It only gets b, c, g, and h if cell e is picked
#       a                    (18,08)
#      b c               (17,09) (18,09)         x is zigzag vertical
#     d e f          (17,10) (18,10) (19,10)     y is horizontal
#      g h               (17,11) (18,11)
#       i                    (18,12)

func get_all_neighbors(coords: Vector2) -> PackedVector2Array:
	var neighbors = []
	neighbors.append_array(Selection.get_surrounding_cells(coords))
	neighbors.append(Vector2(coords.x+1, coords.y))
	neighbors.append(Vector2(coords.x-1, coords.y))
	neighbors.append(Vector2(coords.x, coords.y-2))
	neighbors.append(Vector2(coords.x, coords.y+2))
	return neighbors


# Example diagram of logic for get_neighbors_by_radius(), it scans from the 
# top down and uses these patterns to determine what cells are neighbors
# dx                  (19,06)                   <- First row, we know it's centered, and there'll only be one, with a Y starting at (coords.y - radius*2)
#                 (18,07) (19,07)               <- One more row, we know the width increases by one
# dx          (18,08) (19,08) (20,08)           <- Odd row, decrement starting x
#         (17,09) (18,09) (19,09) (20,09)
#     (17,10) (18,10) (19,10) (20,10) (21,10)   <- Horizontal center row, we know it will decrease width from now on
# ix      (17,11) (18,11) (19,11) (20,11)       <- 2nd row with the same X, increment starting x by 1
#             (18,12) (19,12) (20,12)
# ix              (18,13) (19,13)
#                     (19,14)                   <- One result, end search

func get_neighbors_by_radius(coords: Vector2, radius: int) -> PackedVector2Array:
	
	# Don't do complicated stuff for the easy stuff
	if (radius < 2):
		return get_all_neighbors(coords)
	
	var neighbors = []
	
	var topCell = coords
	topCell.y -= radius * 2
	
	var rowWidth = 1
	var xStart = topCell.x
	var updateXStartForRow = false
	
	var middleRowReached = false
	
	var row = topCell.y
	while rowWidth > 0:
		
		# Check for middle row reached if it hasn't yet
		if(!middleRowReached && row == coords.y):
			middleRowReached = true
			updateXStartForRow = true
		
		updateXStartForRow = !updateXStartForRow
		
		# Add all for this row
		var i = rowWidth - 1
		while i >= 0:
			neighbors.append(Vector2(xStart + i, row))
			i -= 1
		
		# Figure out where the start is for the next row
		if(updateXStartForRow):
			if(middleRowReached):
				xStart += 1
			else:
				xStart -= 1
		
		# Figure out the next row's width
		if(middleRowReached):
			rowWidth -= 1
		else:
			rowWidth += 1
		
		row += 1
	
	return neighbors
