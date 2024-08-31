extends TileMap

func moveTileToLayer(currentLayer, newLayer, coords, tileToLeaveBehind, layerToleaveBehind):
	
	# Guard against nulls
	if(currentLayer == null || newLayer	== null || coords == null):
		return
	
	# Find out what it is
	var sourceId = get_cell_source_id(currentLayer, coords)		
	var atlasCoords = get_cell_atlas_coords(currentLayer, coords)
	
	# Guard against tiles that can't be destroyed
	if(!TileDefs.DestructibleTiles.has(sourceId)):
		return
	
	# Guard against movement on irradiated cells
	if(get_cell_source_id(LayerDefs.IrradiatedGround, coords) == TileDefs.IrradiatedEarth):
		return
	
	# Set new layer if it can be moved
	if(TileDefs.MovableTiles.has(sourceId)):
		set_cell(newLayer, coords, sourceId, atlasCoords)
	
	# Erase old layer
	erase_cell(currentLayer, coords)
	
	# Leave behind a tile on move if applicable
	if(tileToLeaveBehind != null && layerToleaveBehind != null):
		set_cell(layerToleaveBehind, coords, tileToLeaveBehind, Vector2(0,0))

func burnTile(coords):
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, coords, TileDefs.Fire, LayerDefs.Foreground)

func destroyTile(coords):
	moveTileToLayer(LayerDefs.Foreground, LayerDefs.DestroyedTiles, coords, TileDefs.Debris, LayerDefs.Foreground)
