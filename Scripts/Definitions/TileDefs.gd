extends Node

# GDScript doesn't permit const enums, and scripts like this are effectively
# treated the same way, so this format is as good as it gets

const Air = -1
const Selector = 0
const AnimatedSelector = 1
const Earth = 2
const Water = 3
const IrradiatedEarth = 4
const Debris = 5
const ResidentialBuilding = 6
const ElectricInfrastructure = 7
const Farmland = 8
const BombShelter = 9
const LaunchTower = 10
const ShieldGenerator = 11
const FireStation = 12
const Fire = 13
const Nature = 14
const Rocks = 15

const BurnableTiles = [ResidentialBuilding, ElectricInfrastructure, 
Farmland, ShieldGenerator, Nature]

const MovableTiles = [ResidentialBuilding, ElectricInfrastructure, 
Farmland, BombShelter, LaunchTower, ShieldGenerator, FireStation,
Nature]

const DestructibleTiles = [ResidentialBuilding, ElectricInfrastructure, 
Farmland, BombShelter, LaunchTower, ShieldGenerator, FireStation,
Nature, Rocks]
