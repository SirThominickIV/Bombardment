extends Node

var tilemap: TileMap
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
	var spawnLocation = tilemap.selectedTile
	spawnLocation.y = tilemap.selectedTile.y - 50
	projectile.position = tilemap.map_to_local(spawnLocation)
	projectile.TargetCoord = tilemap.map_to_local(tilemap.selectedTile)
	projectile.ProjectileType = projectileType

func doStandardArtilleryDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.local_to_map(targetPosition)
	
	# Erase two random nearby cells
	var relativeCoords = localTargetPosition;
	relativeCoords.x = localTargetPosition.x + random.randi_range(-1, 1)
	relativeCoords.y = localTargetPosition.y + random.randi_range(-1, 1)
	tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	relativeCoords.x = localTargetPosition.x + random.randi_range(-1, 1)
	relativeCoords.y = localTargetPosition.y + random.randi_range(-1, 1)
	tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	
	# Erase the selected one
	tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.Debris, LayerDefs.Foreground)	

func doNukeDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = tilemap.local_to_map(targetPosition)
		
	# Erase random nearby cells, replace with debris/fire
	for i in range(13):
		var relativeCoords = localTargetPosition;
		relativeCoords.x = localTargetPosition.x + random.randi_range(-3, 3)
		relativeCoords.y = localTargetPosition.y + random.randi_range(-3, 3)
		
		# Do either fire or debris based on if var i is even or odd
		if(i % 2 == 0):
			tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
		else:
			tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Fire, LayerDefs.Foreground)	
	
	# Set a number of cells to irradiated tiles
	for i in range(13):
		var relativeCoords = localTargetPosition;
		relativeCoords.x = localTargetPosition.x + random.randi_range(-2, 2)
		relativeCoords.y = localTargetPosition.y + random.randi_range(-2, 2)
		tilemap.erase_cell(LayerDefs.Foreground, relativeCoords)
		
		if(tilemap.get_cell_source_id(LayerDefs.Ground, relativeCoords) == TileDefs.Earth):
			tilemap.set_cell(LayerDefs.IrradiatedGround, relativeCoords, TileDefs.IrradiatedEarth, Vector2(0,0))
	
	# Set the selected one
	tilemap.moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)
		


