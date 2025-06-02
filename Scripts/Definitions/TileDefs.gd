extends Node

enum Tile{
	Air = -1,
	Selector = 0,
	AnimatedSelector = 1,
	Earth = 2,
	Water = 3,
	IrradiatedEarth = 4,
	Debris = 5,
	ResidentialBuilding = 6,
	ElectricInfrastructure = 7,
	Farmland = 8,
	Bunker = 9,
	LaunchTower = 10,
	ShieldGenerator = 11,
	FireStation = 12,
	Fire = 13,
	Nature = 14,
	Mountain = 15,
	Construction = 16,
}

const Burnable = [Tile.ResidentialBuilding, Tile.ElectricInfrastructure, 
Tile.Farmland, Tile.ShieldGenerator, Tile.Nature]

const Rebuildable = [Tile.Bunker, Tile.LaunchTower, Tile.ShieldGenerator, 
Tile.FireStation]

const Resistant = [Tile.Bunker, Tile.Mountain]

const Invulnerable = [Tile.IrradiatedEarth]
