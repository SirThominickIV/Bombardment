extends Node2D

# TODO : Eventually the level that gets loaded should be
# handled through UI. For now this works.
func _ready():
	var level = SceneDefs.level01.instantiate()
	add_child(level)
