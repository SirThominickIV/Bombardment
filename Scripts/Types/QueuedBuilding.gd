class_name QueuedBuilding
extends Resource

var coords: Vector2i
var type: TileDefs.Tile
var time: float = 1.0
var size: int = 0

func _init(in_coords: Vector2i, 
	in_type: TileDefs.Tile, 
	in_time: float = 1.0, 
	in_size: int = 0) -> void:
		coords = in_coords
		type = in_type
		time = in_time
		size = in_size
