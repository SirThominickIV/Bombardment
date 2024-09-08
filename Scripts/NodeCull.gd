extends Node
class_name NodeCull

@export var TicksUntilCull = 200.0

func _physics_process(_delta):
	TicksUntilCull -= 1
	if(TicksUntilCull < 0):
		queue_free()
