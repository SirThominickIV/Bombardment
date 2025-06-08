extends Node
class_name  WeaponController

@onready var mainController: MainController = get_node('/root/MainController') as MainController
var tilemap: TilemapController
var selectorController: SelectorController
var enemyController: EnemyController
var uiController: UIController
var random = RandomNumberGenerator.new()

var cooldown: float

var standard_artillery_count: int
var incendiary_count: int
var rods_from_the_gods_count: int
var nuke_count: int

func _process(_delta):
	if(cooldown > 0):
		cooldown -= _delta

func reset() -> void:
	
	cooldown = 0
	
	# Reset weapon counts
	standard_artillery_count = ProjectileDefs.StandardArtilleryLimit
	incendiary_count = ProjectileDefs.IncendiaryLimit
	rods_from_the_gods_count = ProjectileDefs.RodsFromTheGodsLimit
	nuke_count = ProjectileDefs.NukeLimit
	
	# Reset UI for counts
	uiController.set_artillery_label(str(standard_artillery_count))
	uiController.set_incendiary_label(str(incendiary_count))
	uiController.set_rodsfromthegods_label(str(rods_from_the_gods_count))
	uiController.set_nuke_label(str(nuke_count))

func spawn_projectile(projectileType):
	
	# Guard against inactive game & cooldown
	if(!mainController.is_game_active || cooldown > 0):
		return
	
	# Spawn the projectile of the correct type
	var projectile = Object
	match projectileType:
		ProjectileDefs.StandardArtillery:
			
			# Guard against none available
			if(standard_artillery_count <= 0):
				return
			
			standard_artillery_count -= 1
			uiController.set_artillery_label(str(standard_artillery_count))
			projectile = SceneDefs.StandardArtillery.instantiate()
			
		ProjectileDefs.Incendiary:
			
			# Guard against none available
			if(incendiary_count <= 0):
				return
			
			incendiary_count -= 1
			uiController.set_incendiary_label(str(incendiary_count))
			projectile = SceneDefs.StandardArtillery.instantiate()
			
		ProjectileDefs.RodsFromTheGods:
			
			# Guard against none available
			if(rods_from_the_gods_count <= 0):
				return
			
			rods_from_the_gods_count -= 1
			uiController.set_rodsfromthegods_label(str(rods_from_the_gods_count))
			projectile = SceneDefs.RodsFromTheGods.instantiate()
			
		ProjectileDefs.Nuke:
			
			# Guard against none available
			if(nuke_count <= 0):
				return
			
			nuke_count -= 1
			uiController.set_nuke_label(str(nuke_count))
			projectile = SceneDefs.Nuke.instantiate()
		_:
			push_error("Cannot instantiate unknown projectile type")
	
	# Keep it as a child so the projectile can
	# report when to do damage
	add_child(projectile)
	
	cooldown = ProjectileDefs.WeaponCooldown
	
	# Do position tracking stuff
	var spawnLocation = selectorController.selectedTile
	spawnLocation.y = selectorController.selectedTile.y - 100
	projectile.position = tilemap.Selection.map_to_local(spawnLocation)
	projectile.TargetCoord = tilemap.Selection.map_to_local(selectorController.selectedTile)
	projectile.ProjectileType = projectileType

func do_standardartillery_damage(coords : Vector2i) -> void:
	# Convert to tilemap position
	var local_coords = tilemap.Selection.local_to_map(coords)
	
	# Erase two random nearby cells
	var targets = tilemap.get_all_neighbors(local_coords)
	tilemap.destroy(targets[random.randi_range(0, 7)])
	tilemap.destroy(targets[random.randi_range(0, 7)])
	tilemap.destroy(local_coords, Destruction.Destruction_Type.Default, true)

func do_nuke_damage(coords: Vector2i) -> void:
	# Convert to tilemap position
	var local_coords = tilemap.Selection.local_to_map(coords)
	
	var targets = tilemap.get_neighbors_by_radius(local_coords, 4)
	for i in range(len(targets)):
		var choice = random.randi_range(0,2)
		if(choice == 0):
			tilemap.destroy(targets[i], Destruction.Destruction_Type.Default)
		elif (choice == 1):
			tilemap.destroy(targets[i], Destruction.Destruction_Type.Irradiated)
		elif (choice == 2):
			tilemap.destroy(targets[i], Destruction.Destruction_Type.Fire)

	# Erase the selected one
	tilemap.destroy(coords, Destruction.Destruction_Type.Irradiated, true)

func do_rods_from_the_gods_damage(coords: Vector2i) -> void:
	# Convert to tilemap position
	var local_coords = tilemap.Selection.local_to_map(coords)
		
	var targets = tilemap.get_neighbors_by_radius(local_coords, 4)
	for i in range(len(targets)):
		if(random.randi_range(0,1) == 0):
			tilemap.destroy(targets[i])
		else:
			tilemap.destroy(targets[i], Destruction.Destruction_Type.Fire)
	
	# Erase the selected one
	tilemap.destroy(local_coords, Destruction.Destruction_Type.Default, true)
	
func do_incendiary_damage(coords: Vector2i) -> void:
	# Convert to tilemap position
	var local_coords = tilemap.Selection.local_to_map(coords)
	
	var targets = tilemap.get_all_neighbors(local_coords)
	for i in range(len(targets)):
		tilemap.destroy(targets[i], Destruction.Destruction_Type.Fire)
	
	# Erase the selected one
	tilemap.destroy(local_coords, Destruction.Destruction_Type.Fire, true)
