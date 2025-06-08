extends Node
class_name NodeCull

@export var ticks_until_cull = 200.0

func _physics_process(_delta):
	ticks_until_cull -= 1
	if(ticks_until_cull < 0):
		queue_free()
