extends Node2D

@export var scene_to_load: String = "res://path/to/scene.tscn"

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file(scene_to_load)
