extends Node2D


func _ready() -> void:
	__use_patterns()
	return


func __use_patterns() -> void:
	var patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/patterns.res"))
	$ObstacleLayers/ChunkLayer.set_pattern(Vector2i(1, 1), patterns.pick_random())
	return
