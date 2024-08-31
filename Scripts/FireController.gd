extends Node

var tilemap: TileMap

var ticks = 0
const ticksNeeded = 1

var random = RandomNumberGenerator.new()

func _physics_process(delta):
	
	# Track fire points
	if(ticks < ticksNeeded):
		ticks += delta	
		return		
	ticks = 0
	
	# Pick a random fire if possible
	var fires = tilemap.get_used_cells_by_id(LayerDefs.Foreground, TileDefs.Fire)
	if (fires == null || fires.size() == 0):
		return
	
	var fire = fires.pick_random()
	
	# Clear the tile
	tilemap.erase_cell(LayerDefs.Foreground, fire)
	
	# Pick a random burnable neighbor if possible
	var burnableNeighbors = GetBurnableNeighbors(fire)	
	if (burnableNeighbors == null || burnableNeighbors.size() == 0):
		return
	var toBurn = burnableNeighbors.pick_random()
	
	# Determine if the fire should spread
	var shouldSpread = true
	shouldSpread = random.randf_range(0, 1) > 0.5
	
	if(!shouldSpread):
		return
		
	# Burn
	tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, toBurn, TileDefs.Fire, LayerDefs.Foreground)	


func GetBurnableNeighbors(fire):
	var neighbors = tilemap.get_surrounding_cells(fire)
	var burnableNeighbors = []
	
	for neighbor in neighbors:
		var id = tilemap.get_cell_source_id(LayerDefs.Foreground, neighbor)
		if(TileDefs.BurnableTiles.has(id)):
			burnableNeighbors.append(neighbor)
	
	return burnableNeighbors
