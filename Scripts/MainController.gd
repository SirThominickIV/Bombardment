extends Node2D

# TODO : Eventually the level that gets loaded should be
# handled through UI. For now this works.
func _ready():
	var level = SceneDefs.level01.instantiate()
	add_child(level)
	
	# Turn off the mouse cursor when inside the window
	# Eventually this will need to be turned back on when hovering over
	# UI panels/elements, but this is better for now
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
 
