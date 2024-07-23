extends "res://Scripts/TilemapExtensions.gd"

var selectedTile = Vector2(0, 0)
var random = RandomNumberGenerator.new()
var selectedProjectile = ProjectileDefs.StandardArtillery

# Using physics processing to keep deletion consistent
func _physics_process(delta):
	
	# Unselect the previous frames selection
	erase_cell(LayerDefs.Selection, selectedTile)
	
	# Grab the selected tile again
	var mousePos : Vector2 = get_global_mouse_position()
	selectedTile = local_to_map(mousePos)
	
	# Set the selector icon to the selected tile
	set_cell(LayerDefs.Selection, selectedTile, TileDefs.Selector, Vector2(0, 0))
	
	# Process the destruction of tile(s) if needed
	if(Input.is_action_just_pressed("mb_left")):	
		spawnProjectile(random.randi_range(0,1))
		#spawnProjectile(selectedProjectile)
		
	# Debug - Restore buildings on right click
	if(Input.is_action_just_pressed("mb_right")):		
		var usedCells = get_used_cells(LayerDefs.DestroyedTiles)
		for cell in usedCells:
			moveTileToLayer(LayerDefs.DestroyedTiles, LayerDefs.Foreground, cell, null, null)

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
	var spawnLocation = selectedTile
	spawnLocation.y = selectedTile.y - 50
	projectile.position = map_to_local(spawnLocation)
	projectile.TargetCoord = map_to_local(selectedTile)
	projectile.ProjectileType = projectileType

func doStandardArtilleryDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = local_to_map(targetPosition)
	
	# Erase two random nearby cells
	var relativeCoords = localTargetPosition;
	relativeCoords.x = localTargetPosition.x + random.randi_range(-1, 1)
	relativeCoords.y = localTargetPosition.y + random.randi_range(-1, 1)
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	relativeCoords.x = localTargetPosition.x + random.randi_range(-1, 1)
	relativeCoords.y = localTargetPosition.y + random.randi_range(-1, 1)
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
	
	# Erase the selected one
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.Debris, LayerDefs.Foreground)	

func doNukeDamage(targetPosition):	
	# Convert to tilemap position
	var localTargetPosition = local_to_map(targetPosition)
		
	# Erase random nearby cells, replace with debris/fire
	for i in range(13):
		var relativeCoords = localTargetPosition;
		relativeCoords.x = localTargetPosition.x + random.randi_range(-3, 3)
		relativeCoords.y = localTargetPosition.y + random.randi_range(-3, 3)
		
		# Do either fire or debris based on if var i is even or odd
		if(i % 2 == 0):
			moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Debris, LayerDefs.Foreground)	
		else:
			moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.Fire, LayerDefs.Foreground)	
	
	# Set a number of cells to irradiated tiles
	for i in range(13):
		var relativeCoords = localTargetPosition;
		relativeCoords.x = localTargetPosition.x + random.randi_range(-2, 2)
		relativeCoords.y = localTargetPosition.y + random.randi_range(-2, 2)
		moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, relativeCoords, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)
	
	# Set the selected one
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, localTargetPosition, TileDefs.IrradiatedEarth, LayerDefs.IrradiatedGround)
		


