extends Node
class_name WelwalaController

# Welwala - Noun - (pejorative) a person obsessed with the 
# gravity well of the inner planets' culture; a "planet-lover"

var random = RandomNumberGenerator.new()
var tilemap: ExtendedTilemap

var buildPoints = 0
const buildPointsNeeded = 2

func _physics_process(delta):
	buildPoints += delta
	
	if(buildPoints > buildPointsNeeded):
		buildPoints = 0
		RebuildRandom()	

func RebuildRandom():	
	# Find out what is destroyed
	var destroyedCells = tilemap.DestroyedTiles.get_used_cells()
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
	tilemap.moveTileToLayer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, cellToRepair)


func CanCellBeBuiltOn(cell):	
	var result = true
	
	# Get all source IDs on foreground and irradiated layer
	var neighborCoords = tilemap.get_all_neighbors(cell)
	neighborCoords.append(cell)	
	var neighborSourceIds = []
	for coord in neighborCoords:
		neighborSourceIds.append(tilemap.Foreground.get_cell_source_id(coord))
		neighborSourceIds.append(tilemap.IrradiatedGround.get_cell_source_id(cell))
	
	# Just get rid of this cell if it is adjacent to irradiated earth
	if(neighborSourceIds.has(TileDefs.IrradiatedEarth)):
		tilemap.DestroyedTiles.erase_cell(cell)
		result = false
	
	# Can't be built on if the cell has fire nearby
	if(neighborSourceIds.has(TileDefs.Fire)):
		result = false
	
	# If the cell itself has debris, don't build, but at least clear it out
	if(tilemap.Foreground.get_cell_source_id(cell) == TileDefs.Debris):
		tilemap.Foreground.erase_cell(cell)
		result = false
	
	return result
