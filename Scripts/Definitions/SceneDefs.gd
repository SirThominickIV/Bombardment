extends Node

# The preload function requires a path to be a constant string, so each
# level/prefab needs to be it's own const. This would have been the prefered
# solution:
# 		func GetLevel(level):
#			var format_string = "res://Scenes/Levels/level%s.tscn"
#			var path = format_string % level.to_string()
#			return preload(path)
# but godot is a little silly. So this is one of the better options:

# Prefabs
const StandardArtillery = preload("res://Scenes/Prefabs/standardArtillery.tscn")
const Nuke = preload("res://Scenes/Prefabs/nuke.tscn")
const Explosion = preload("res://Scenes/Prefabs/explosion.tscn")
const NuclearExplosion = preload("res://Scenes/Prefabs/nuclearExplosion.tscn")

# Controllers
const WelwalaController = preload("res://Scenes/Controllers/welwala_controller.tscn")
	
# Levels
const level01 = preload("res://Scenes/Levels/level01.tscn")
