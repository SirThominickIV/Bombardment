extends TileMap

func moveTileToLayer(currentLayer, newLayer, coords, tileToLeaveBehind, layerToleaveBehind):
		
	# Guard against nulls
	if(currentLayer == null || newLayer	== null || coords == null):
		return
	
	# Find out what it is
	var sourceId = get_cell_source_id(currentLayer, coords)		
	var atlasCoords = get_cell_atlas_coords(currentLayer, coords)
	
	# Guard against cells that shouldn't be destroyed
	if(!CanTileBeDestroyed(sourceId)):
		return
		
	# Guard against movement on irradiated cells
	if(get_cell_source_id(LayerDefs.IrradiatedGround, coords) == TileDefs.IrradiatedEarth):
		return
		
	# Set new layer
	if(CanTileBeMoved(sourceId)):
		set_cell(newLayer, coords, sourceId, atlasCoords)
		
	# Erase old layer
	erase_cell(currentLayer, coords)
	
	# Leave behind a tile on move if applicable
	if(tileToLeaveBehind != null && layerToleaveBehind != null):
		set_cell(layerToleaveBehind, coords, tileToLeaveBehind, Vector2(0,0))

func CanTileBeMoved(sourceId):
	match sourceId:
		TileDefs.Air:
			return false
		TileDefs.Selector:
			return false
		TileDefs.Earth:
			return false
		TileDefs.IrradiatedEarth:
			return false
		TileDefs.Debris:
			return false
		TileDefs.ResidentialBuildding:
			return true
		TileDefs.ElectricInfrastructure:
			return true
		TileDefs.Farmland:
			return true
		TileDefs.BombShelter:
			return true
		TileDefs.MissileSilo:
			return true
		TileDefs.ShieldGenerator:
			return true
		TileDefs.FireStation:
			return true
		TileDefs.Fire:
			return false
		TileDefs.Burnable_Nature:
			return true
		TileDefs.Rocks:
			return false
		_:
			return true
			
func CanTileBeDestroyed(sourceId):
	match sourceId:
		TileDefs.Air:
			return false
		TileDefs.Selector:
			return false
		TileDefs.Earth:
			return false
		TileDefs.IrradiatedEarth:
			return false
		TileDefs.Debris:
			return true
		TileDefs.ResidentialBuildding:
			return true
		TileDefs.ElectricInfrastructure:
			return true
		TileDefs.Farmland:
			return true
		TileDefs.BombShelter:
			return true
		TileDefs.MissileSilo:
			return true
		TileDefs.ShieldGenerator:
			return true
		TileDefs.FireStation:
			return true
		TileDefs.Fire:
			return false
		TileDefs.Burnable_Nature:
			return true
		TileDefs.Rocks:
			return true
		_:
			return true
