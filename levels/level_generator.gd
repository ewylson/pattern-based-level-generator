extends Node2D


func _ready() -> void:
	__use_patterns()
	return


func __use_patterns() -> void:
	var patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/patterns.res"))
	var obstacles_layer : TileMapLayer = $ObstaclesLayer
	for chunk_start_cell : Vector2i in obstacles_layer.get_used_cells():
		obstacles_layer.set_pattern(chunk_start_cell, patterns.pick_random())
	return
