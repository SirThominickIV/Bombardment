extends Node
class_name NodeCull

var TimeUntilCull = 1000.0

func _process(delta):
	TimeUntilCull = TimeUntilCull - delta
	
	if(TimeUntilCull < 0):
		queue_free()
