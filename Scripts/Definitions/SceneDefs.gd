extends Node



const StandardArtillery = preload("res://Scenes/standardArtillery.tscn")
const Nuke = preload("res://Scenes/nuke.tscn")
const Explosion = preload("res://Scenes/explosion.tscn")
const NuclearExplosion = preload("res://Scenes/nuclearExplosion.tscn")


# Preloading requires a path to be a constant string, so each
# level needs to be it's own const. This would have been the prefered
# solution:
#func GetLevel(level):
	#var format_string = "res://Scenes/Levels/level%s.tscn"
	#var path = format_string % level.to_string()
	#return preload(path)
	
const level01 = preload("res://Scenes/Levels/level01.tscn")
