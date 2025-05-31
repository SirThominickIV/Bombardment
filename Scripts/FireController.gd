extends Node
class_name FireController

var tilemap: TilemapController

var ticks = 0
const ticksNeeded = 1

var random = RandomNumberGenerator.new()

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _physics_process(delta):
	if(!mainController.is_game_active):
		return
	
	# Track fire points
	if(ticks < ticksNeeded):
		ticks += delta
		return
	ticks = 0
	
	# Pick a random fire if possible
	var fires = tilemap.Foreground.get_used_cells_by_id(TileDefs.Fire)
	if (fires == null || fires.size() == 0):
		return
	
	var fire = fires.pick_random()
	
	# Pick a random burnable neighbor if possible
	var burnableNeighbors = get_burnable_neighbors(fire)
	if (burnableNeighbors == null || burnableNeighbors.size() == 0):
		# Clear the tile & stop
		tilemap.Foreground.erase_cell(fire)
		return
	
	var toBurn = burnableNeighbors.pick_random()
	
	# Determine if the fire should spread
	var shouldSpread = true
	shouldSpread = random.randf_range(0, 1) <= get_burn_chances(toBurn)
	
	if(!shouldSpread):
		# Clear the tile & stop
		tilemap.Foreground.erase_cell(fire)
		return
	
	# Burn
	tilemap.burnTile((toBurn))

func reset() -> void:
	ticks = 0

func get_burn_chances(fire: Vector2) -> float:
	var fireStations = tilemap.Foreground.get_used_cells_by_id(TileDefs.FireStation)
	var chance = 1.0
	
	# Firestation within 1 tile = no fire possible
	#                    2 tile = 0.5 reduced chance
	#                    3 tile = 0.33 reduced chance
	#                    ...
	for station in fireStations:
		chance -= 1/fire.distance_to(station)
		if (chance <= 0):
			return 0
	
	return chance


func get_burnable_neighbors(fire : Vector2):
	var neighbors = tilemap.Foreground.get_surrounding_cells(fire)
	var burnableNeighbors = []
	
	for neighbor in neighbors:
		var id = tilemap.Foreground.get_cell_source_id(neighbor)
		if(TileDefs.BurnableTiles.has(id)):
			burnableNeighbors.append(neighbor)
	
	return burnableNeighbors
