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
const build_points_needed = 20

var build_queue: Array[QueuedBuilding] = []

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func _physics_process(delta):
	if(!mainController.is_game_active):
		return
	
	build_points += delta
	
	do_launch_tower_logic()
	
	if(len(available_launch_towers) > 0 && build_points > build_points_needed):
		build_points = 0
		spawn_rocket()
	
	# Queue a building if possible
	if(build_points > build_points_needed):
		var choices = [0,1]
		var choice = choices.pick_random()
		match choice:
			0:
				build_random(TileDefs.Tile.Bunker, 30, 0)
			1:
				build_random(TileDefs.Tile.LaunchTower, 40, 3)
	
	check_build_queue(delta)


func reset() -> void:
	for child in get_children():
		child.queue_free()
	build_points = 0
	launch_towers.clear()
	available_launch_towers.clear()
	
	civilians = tilemap.Foreground.get_used_cells_by_id(TileDefs.Tile.ResidentialBuilding)
	civilian_count_at_start = len(civilians)

func kill_enemy(coords: Vector2i) -> void:
	
	# Check for civilians
	var index_to_pop = civilians.find(coords)
	if(index_to_pop >= 0):
		civilians.pop_at(index_to_pop)
	
	if(civilians.is_empty()):
		get_parent().end_game(true)
	
	# Check for build queue
	for i in range(0,len(build_queue)):
		if build_queue[i].coords == coords:
			build_queue.pop_at(i)
			break

func spawn_rocket() -> void:
	var rocket = SceneDefs.Rocket.instantiate()
	var coords = available_launch_towers.pick_random()
	
	# Enemy rocket tracking
	rockets.append(coords)
	available_launch_towers.pop_at(available_launch_towers.find(coords))
	add_child(rocket)
	
	# Rocket vars
	rocket.tower_coords = coords
	rocket.tilemap = tilemap
	var spawn_coords = tilemap.Foreground.map_to_local(coords)
	spawn_coords = rocket.to_global(spawn_coords)
	spawn_coords.x -= 433.5 # Offset because tiles are off by a little bit
	spawn_coords.y -= 344.0
	rocket.position = spawn_coords

func remove_rocket(coords: Vector2i) -> void:
	rockets.pop_at(rockets.find(coords))

func do_launch_tower_logic() -> void:
	launch_towers = tilemap.Foreground.get_used_cells_by_id(TileDefs.Tile.LaunchTower)
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

func build_random(type: TileDefs.Tile, time: float, size: int) -> void:
	# Find Space
	var open_spaces = tilemap.get_empty_foreground()
	
	# Guard against no spaces
	if not len(open_spaces):
		return
	
	var coords = open_spaces[random.randi_range(0, len(open_spaces)-1)]
	
	if not can_cell_be_built_on(coords):
		return
	
	# Queue it
	var building = QueuedBuilding.new(coords, type, time, size)
	build_queue.append(building)
	
	# Set temp texture
	var atlas = Vector2i(random.randi_range(0,7),size)
	tilemap.Foreground.set_cell(coords, TileDefs.Tile.Construction, atlas)
	
	build_points = 0

func check_build_queue(delta: float) -> void:
	if(!len(build_queue)):
		return
	
	# Sort queue
	build_queue.sort_custom(func(a,b): return a.time < b.time)
	
	# Run through queue
	for building in build_queue:
		building.time -= delta
		
		if(building.time <= 0):
			# Finished, set it to it's final, and remove it from the queue
			tilemap.Foreground.set_cell(building.coords, building.type, Vector2i(0,0))
			build_queue.pop_front()
			continue

func can_cell_be_built_on(cell) -> bool:	
	var result = true
	
	# Get all source IDs on foreground and irradiated layer
	var neighbor_coords = tilemap.get_all_neighbors(cell)
	neighbor_coords.append(cell)	
	var neighbor_source_ids = []
	for coord in neighbor_coords:
		neighbor_source_ids.append(tilemap.Foreground.get_cell_source_id(coord))
	
	# Can't be built on if the cell has fire nearby
	if(neighbor_source_ids.has(TileDefs.Tile.Fire)):
		result = false
	
	# Can't be built on if the cell has irradited earth nearby
	if(neighbor_source_ids.has(TileDefs.Tile.IrradiatedEarth)):
		result = false
	
	# If the cell itself has debris, don't build, but at least clear it out
	if(tilemap.Foreground.get_cell_source_id(cell) == TileDefs.Tile.Debris):
		tilemap.Foreground.erase_cell(cell)
		result = false
	
	return result
