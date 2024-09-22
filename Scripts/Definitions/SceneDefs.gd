extends Node

# The preload function requires a path to be a constant string, so each
# level/prefab needs to be it's own const. This would have been the prefered
# solution:
# 		func GetPrefab(prefab):
#			var path = "res://Scenes/Levels/{prefab}.tscn"
#			return preload(path)
# but godot is a little silly. So this is one of the better options:

# Prefabs
const StandardArtillery = preload("res://Scenes/Prefabs/standardArtillery.tscn")
const Nuke = preload("res://Scenes/Prefabs/nuke.tscn")
const Explosion = preload("res://Scenes/Prefabs/explosion.tscn")
const NuclearExplosion = preload("res://Scenes/Prefabs/nuclearExplosion.tscn")
const Rocket = preload("res://Scenes/Prefabs/rocket.tscn")

# Levels
const Levels = [preload("res://Scenes/Levels/level01.tscn")]
