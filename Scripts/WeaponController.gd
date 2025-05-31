extends Node
class_name  WeaponController

var tilemap: TilemapController
var selectorController: SelectorController
var enemyController: EnemyController
var uiController: UIController
var random = RandomNumberGenerator.new()

var cooldown: float

var standardArtilleryCount: int
var incendiaryCount: int
var rodsFromTheGodsCount: int
var nukeCount: int

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func spawnProjectile(projectileType):
	
	# Guard against inactive game & cooldown
	if(!mainController.is_game_active || cooldown > 0):
		return
	
	# Spawn the projectile of the correct type
	var projectile = Object
	match projectileType:
		ProjectileDefs.StandardArtillery:
			
			# Guard against none available
			if(standardArtilleryCount <= 0):
				return
			
			standardArtilleryCount -= 1
			uiController.set_artillery_label(str(standardArtilleryCount))
			projectile = SceneDefs.StandardArtillery.instantiate()
			
		ProjectileDefs.Incendiary:
			
			# Guard against none available
			if(incendiaryCount <= 0):
				return
			
			incendiaryCount -= 1
			uiController.set_incendiary_label(str(incendiaryCount))
			projectile = SceneDefs.StandardArtillery.instantiate()
			
		ProjectileDefs.RodsFromTheGods:
			
			# Guard against none available
			if(rodsFromTheGodsCount <= 0):
				return
			
			rodsFromTheGodsCount -= 1
			uiController.set_rodsfromthegods_label(str(rodsFromTheGodsCount))
			projectile = SceneDefs.RodsFromTheGods.instantiate()
			
		ProjectileDefs.Nuke:
			
			# Guard against none available
			if(nukeCount <= 0):
				return
			
			nukeCount -= 1
			uiController.set_nuke_label(str(nukeCount))
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

func _process(_delta):
	if(cooldown > 0):
		cooldown -= _delta

func reset() -> void:
	
	cooldown = 0
	
	# Reset weapon counts
	standardArtilleryCount = ProjectileDefs.StandardArtilleryLimit
	incendiaryCount = ProjectileDefs.IncendiaryLimit
	rodsFromTheGodsCount = ProjectileDefs.RodsFromTheGodsLimit
	nukeCount = ProjectileDefs.NukeLimit
	
	# Reset UI for counts
	uiController.set_artillery_label(str(standardArtilleryCount))
	uiController.set_incendiary_label(str(incendiaryCount))
	uiController.set_rodsfromthegods_label(str(rodsFromTheGodsCount))
	uiController.set_nuke_label(str(nukeCount))

func doStandardArtilleryDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
	
	# Erase two random nearby cells
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	tilemap.destroyTile(targets[random.randi_range(0, 7)])
	tilemap.destroyTile(targets[random.randi_range(0, 7)])
	tilemap.destroyTile(localTargetPosition)

func doNukeDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
	
	var targets = tilemap.get_neighbors_by_radius(localTargetPosition, 4)
	for i in range(len(targets)):
		if(random.randi_range(0,1) == 0):
			tilemap.destroyTile(targets[i])
		else:
			tilemap.burnTile(targets[i])

	# Erase the selected one
	tilemap.nukeTile(localTargetPosition)

func doRodsFromTheGodsDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
		
	var targets = tilemap.get_neighbors_by_radius(localTargetPosition, 4)
	for i in range(len(targets)):
		if(random.randi_range(0,1) == 0):
			tilemap.destroyTile(targets[i])
		else:
			tilemap.burnTile(targets[i])
	
	# Erase the selected one
	tilemap.nukeTile(localTargetPosition)
	
func doIncendiaryDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
	
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	for i in range(len(targets)):
		tilemap.burnTile(targets[i])
	
	# Erase the selected one
	tilemap.burnTile(localTargetPosition)
