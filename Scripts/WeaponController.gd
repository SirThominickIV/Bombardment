extends Node
class_name  WeaponController

var tilemap : ExtendedTilemap
var selectorController
var random = RandomNumberGenerator.new()

func spawnProjectile(projectileType):
	
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
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[random.randi_range(0, 7)], TileDefs.Debris, LayerDefs.Foreground)
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[random.randi_range(0, 7)], TileDefs.Debris, LayerDefs.Foreground)
	
	# Erase the selected one
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.Debris, LayerDefs.Foreground)	

func doNukeDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
	
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	
	for i in range(7):
		if(random.randi_range(0,1) == 0):
			tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[i], TileDefs.Debris, LayerDefs.Foreground)	
		else:
			tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[i], TileDefs.Fire, LayerDefs.Foreground)	
	
	# Set the selected one
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)


func doRodsFromTheGodsDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
		
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	for i in range(7):
		if(random.randi_range(0,1) == 0):
			tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[i], TileDefs.Debris, LayerDefs.Foreground)	
		else:
			tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[i], TileDefs.Fire, LayerDefs.Foreground)	
	
	# Erase the selected one
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.Debris, LayerDefs.Foreground)	

func doIncendiaryDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.Selection.local_to_map(targetPosition)
	
	var targets = tilemap.get_all_neighbors(localTargetPosition)
	for i in range(7):
		tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, targets[i], TileDefs.Fire, LayerDefs.Foreground)	
	
	# Erase the selected one
	tilemap.moveTileToLayerWithLeaveBehind(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.Fire, LayerDefs.Foreground)	
