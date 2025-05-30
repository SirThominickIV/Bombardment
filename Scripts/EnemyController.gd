extends Node
class_name EnemyController

var random = RandomNumberGenerator.new()
var tilemap: TilemapController

# Defense
var civilians: Array[Vector2i] = [] # Source of truth for enemy "health"
var civilian_count_at_start: int = 0

# Offense
var launch_towers : Array[Vector2i] = []
var available_launch_towers: Array[Vector2i] = []
var rockets: Array[Vector2i] = []

var build_points = 0
const build_points_needed = 2

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _physics_process(delta):
	if(!mainController.is_game_active):
		return
	
	build_points += delta
	
	do_launch_tower_logic()
	
	if(len(available_launch_towers) > 0 && build_points > build_points_needed):
		build_points = 0
		spawn_rocket()
	
	#if(build_points > build_points_needed):
		#build_points = 0
		#rebuild_random()

func reset() -> void:
	for child in get_children():
		child.queue_free()
	build_points = 0
	launch_towers.clear()
	available_launch_towers.clear()
	
	civilians = tilemap.Foreground.get_used_cells_by_id(TileDefs.ResidentialBuilding)
	civilian_count_at_start = len(civilians)

func kill_civilian(coords: Vector2i) -> void:
	var index_to_pop = civilians.find(coords)
	if(index_to_pop >= 0):
		civilians.pop_at(index_to_pop)
	
	if(civilians.is_empty()):
		get_parent().end_game(true)

func spawn_rocket() -> void:
	var rocket = SceneDefs.Rocket.instantiate()
	var coords = available_launch_towers.pick_random()
	
	# Enemy rocket tracking
	rockets.append(coords)
	available_launch_towers.pop_at(available_launch_towers.find(coords))
	add_child(rocket)
	
	# Rocket vars
	rocket.towerCoords = coords
	rocket.tilemap = tilemap
	var spawn_coords = tilemap.Foreground.map_to_local(coords)
	spawn_coords = rocket.to_global(spawn_coords)
	spawn_coords.x -= 433.5 # Offset because tiles are off by a little bit
	spawn_coords.y -= 344.0
	rocket.position = spawn_coords

func remove_rocket(coords: Vector2i) -> void:
	rockets.pop_at(rockets.find(coords))

func do_launch_tower_logic() -> void:
	launch_towers = tilemap.Foreground.get_used_cells_by_id(TileDefs.LaunchTower)
	for tile in launch_towers:
		
		# Don't add tiles to available_launch_towers if there is a rocket
		if rockets.has(tile):
			# Remove towers from available if it has a rocket
			if(available_launch_towers.has(tile)):
				available_launch_towers.pop_at(available_launch_towers.find(tile))
			continue
		
		# Add tile to available_launch_towers
		if(!available_launch_towers.has(tile)):
			available_launch_towers.append(tile)
	
	# Clear available list to keep up with destroyed towers
	for tile in available_launch_towers:
		if !launch_towers.has(tile):
			available_launch_towers.pop_at(available_launch_towers.find(tile))

func rebuild_random() -> void:	
	# Find out what is destroyed
	var destroyed_cells = tilemap.DestroyedTiles.get_used_cells()
	if (destroyed_cells == null || destroyed_cells.size() == 0):
		return
	
	# Find out what is repairable
	var repairableCells = []
	for cell in destroyed_cells:
		if(can_cell_be_built_on(cell)):
			repairableCells.append(cell)
	if(repairableCells.size() == 0):
		return
	
	# Repair something
	var cellToRepair = repairableCells.pick_random()	
	tilemap.move_to_layer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, cellToRepair)

func can_cell_be_built_on(cell) -> bool:	
	var result = true
	
	# Get all source IDs on foreground and irradiated layer
	var neighbor_coords = tilemap.get_all_neighbors(cell)
	neighbor_coords.append(cell)	
	var neighbor_source_ids = []
	for coord in neighbor_coords:
		neighbor_source_ids.append(tilemap.Foreground.get_cell_source_id(coord))
		neighbor_source_ids.append(tilemap.IrradiatedGround.get_cell_source_id(cell))
	
	# Just get rid of this cell if it is adjacent to irradiated earth
	if(neighbor_source_ids.has(TileDefs.IrradiatedEarth)):
		tilemap.DestroyedTiles.erase_cell(cell)
		result = false
	
	# Can't be built on if the cell has fire nearby
	if(neighbor_source_ids.has(TileDefs.Fire)):
		result = false
	
	# If the cell itself has debris, don't build, but at least clear it out
	if(tilemap.Foreground.get_cell_source_id(cell) == TileDefs.Debris):
		tilemap.Foreground.erase_cell(cell)
		result = false
	
	return result
