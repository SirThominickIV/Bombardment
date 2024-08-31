extends Node

# Welwala - Noun - (pejorative) a person obsessed with the 
# gravity well of the inner planets' culture; a "planet-lover"

var random = RandomNumberGenerator.new()
var tilemap: TileMap
var buildPoints = 0
const buildPointsNeeded = 2

func _physics_process(delta):
	buildPoints += delta
	
	if(buildPoints > buildPointsNeeded):
		buildPoints = 0
		RebuildRandom()	

func RebuildRandom():	
	# Find out what is destroyed
	var destroyedCells = tilemap.get_used_cells(LayerDefs.DestroyedTiles)
	if (destroyedCells == null || destroyedCells.size() == 0):
		return
	
	# Find out what is repairable
	var repairableCells = []
	for cell in destroyedCells:
		if(CanCellBeBuiltOn(cell)):
			repairableCells.append(cell)
	if(repairableCells.size() == 0):
		return
	
	# Repair something
	var cellToRepair = repairableCells.pick_random()	
	tilemap.moveTileToLayer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, cellToRepair, null, null)


func CanCellBeBuiltOn(cell):	
	var result = true
	
	# Get all source IDs on foreground and irradiated layer
	var neighborCoords = tilemap.get_surrounding_cells(cell)
	neighborCoords.append(cell)	
	var neighborSourceIds = []
	for coord in neighborCoords:
		neighborSourceIds.append(tilemap.get_cell_source_id(LayerDefs.Foreground, coord))
		neighborSourceIds.append(tilemap.get_cell_source_id(LayerDefs.IrradiatedGround, coord))
	
	# Just get rid of this cell if it is adjacent to irradiated earth
	if(neighborSourceIds.has(TileDefs.IrradiatedEarth)):
		tilemap.erase_cell(LayerDefs.DestroyedTiles, cell)
		result = false
	
	# Can't be built on if the cell has fire nearby
	if(neighborSourceIds.has(TileDefs.Fire)):
		result = false
	
	# If the cell itself has debris, don't build, but at least clear it out
	if(tilemap.get_cell_source_id(LayerDefs.Foreground, cell) == TileDefs.Debris):
		tilemap.erase_cell(LayerDefs.Foreground, cell)
		result = false
	
	return result
