extends Node
class_name WelwalaController

# Welwala - Noun - (pejorative) a person obsessed with the 
# gravity well of the inner planets' culture; a "planet-lover"

var random = RandomNumberGenerator.new()
var tilemap: ExtendedTilemap

var launchTowers : Array[Vector2i] = []
var availableLaunchTowers: Array[Vector2i] = []
var rockets: Array[Vector2i] = []

var buildPoints = 0
const buildPointsNeeded = 2

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _physics_process(delta):
	if(!mainController.IsGameActive):
		return
	
	buildPoints += delta
	
	DoLaunchTowerLogic()
	
	if(len(availableLaunchTowers) > 0 && buildPoints > buildPointsNeeded):
		buildPoints = 0
		SpawnRocket()
	
	if(buildPoints > buildPointsNeeded):
		buildPoints = 0
		RebuildRandom()

func reset() -> void:
	for child in get_children():
		child.queue_free()
	buildPoints = 0
	launchTowers.clear()
	availableLaunchTowers.clear()

func SpawnRocket() -> void:
	var rocket = SceneDefs.Rocket.instantiate()
	var coords = availableLaunchTowers.pick_random()
	
	# Welwala rocket tracking
	rockets.append(coords)
	availableLaunchTowers.pop_at(availableLaunchTowers.find(coords))
	add_child(rocket)
	
	# Rocket vars
	rocket.towerCoords = coords
	rocket.tilemap = tilemap
	var spawnCoords = tilemap.Foreground.map_to_local(coords)
	spawnCoords = rocket.to_global(spawnCoords)
	spawnCoords.x -= 433.5 # Offset because tiles are off by a little bit
	spawnCoords.y -= 344.0
	rocket.position = spawnCoords

func RemoveRocket(coords: Vector2i) -> void:
	rockets.pop_at(rockets.find(coords))

func DoLaunchTowerLogic() -> void:
	launchTowers = tilemap.Foreground.get_used_cells_by_id(TileDefs.LaunchTower)
	for tile in launchTowers:
		
		# Don't add tiles to availableLaunchTowers if there is a rocket
		if rockets.has(tile):
			# Remove towers from available if it has a rocket
			if(availableLaunchTowers.has(tile)):
				availableLaunchTowers.pop_at(availableLaunchTowers.find(tile))
			continue
			
		# Add tile to availableLaunchTowers
		if(!availableLaunchTowers.has(tile)):
			availableLaunchTowers.append(tile)
	
	# Clear available list to keep up with destroyed towers
	for tile in availableLaunchTowers:
		if !launchTowers.has(tile):
			availableLaunchTowers.pop_at(availableLaunchTowers.find(tile))

func RebuildRandom() -> void:	
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

func CanCellBeBuiltOn(cell) -> bool:	
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
