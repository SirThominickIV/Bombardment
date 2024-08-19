extends Node

# Welwala - Noun - (pejorative) a person obsessed with the 
# gravity well of the inner planets' culture; a "planet-lover"

var random = RandomNumberGenerator.new()
var tilemap
var buildPoints = 0
const buildPointsNeeded = 5

func _physics_process(delta):
	buildPoints += delta
	
	if(buildPoints > buildPointsNeeded):
		buildPoints = 0
		RebuildRandom()	

func RebuildRandom():	

	var destroyedCells = tilemap.get_used_cells(LayerDefs.DestroyedTiles)
	
	if (destroyedCells.size() == 0):
		return
	
	var cellToRepair = random.randi_range(0, destroyedCells.size() - 1)
	
	tilemap.moveTileToLayer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, destroyedCells[cellToRepair], null, null)


