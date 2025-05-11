extends Node
class_name  WeaponController

var tilemap: TilemapController
var selectorController: SelectorController
var enemyController: EnemyController
var random = RandomNumberGenerator.new()

@onready var mainController: MainController = get_node('/root/MainController') as MainController

func spawnProjectile(projectileType):	
	if(!mainController.IsGameActive):
		return
	
	# Spawn the projectile of the correct type
	var projectile = Object
	match projectileType:
		ProjectileDefs.StandardArtillery:
			projectile = SceneDefs.StandardArtillery.instantiate()	
		ProjectileDefs.Nuke:
			projectile = SceneDefs.Nuke.instantiate()	
		_:
			projectile = SceneDefs.StandardArtillery.instantiate()	
	
	# Keep it as a child so the projectile can
	# report when to do damage
	add_child(projectile)
	
	# Do position tracking stuff
	var spawnLocation = selectorController.selectedTile
	spawnLocation.y = selectorController.selectedTile.y - 50
	projectile.position = tilemap.Selection.map_to_local(spawnLocation)
	projectile.TargetCoord = tilemap.Selection.map_to_local(selectorController.selectedTile)
	projectile.ProjectileType = projectileType

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
	
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	
	for i in range(7):
		if(random.randi_range(0,1) == 0):
			tilemap.destroyTile(targets[i])
		else:
			tilemap.burnTile(targets[i])

	# Erase the selected one
	tilemap.nukeTile(localTargetPosition)

func doRodsFromTheGodsDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
		
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	for i in range(7):
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
	for i in range(7):
		tilemap.burnTile(targets[i])
	
	# Erase the selected one
	tilemap.burnTile(localTargetPosition)
