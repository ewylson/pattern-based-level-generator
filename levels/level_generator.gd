extends Node2D


@export_group("Layers")
@export var ground_layer : TileMapLayer
@export var obstacles_layer : TileMapLayer

@export_group("Chunk Grid")
@export var chunk_size := Vector2i(5, 5)
@export var chunk_grid_padding := Vector2i(2, 2)


func _ready() -> void:
	var patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/patterns.res"))
	for start_cell : Vector2i in __get_chunk_start_cells():
		obstacles_layer.set_pattern(start_cell, patterns.pick_random())
	return


func __get_chunk_start_cells() -> Array[Vector2i]:
	var chunk_start_cells : Array[Vector2i]
	var chunk_grid_size : Vector2i = __get_chunk_grid_size()
	for row in range(chunk_grid_size.x):
		for col in range(chunk_grid_size.y):
			chunk_start_cells.append(__get_start_cell_on_chunk(Vector2i(row, col)))
	return chunk_start_cells


func __get_chunk_grid_size() -> Vector2i:
	return (ground_layer.get_used_rect().size - chunk_grid_padding) / chunk_size


func __get_start_cell_on_chunk(chunk_coords: Vector2i) -> Vector2i:
	var cell_coords_offset : Vector2i = chunk_grid_padding / 2
	return Vector2i(chunk_coords.x * chunk_size.x + cell_coords_offset.x, chunk_coords.y * chunk_size.y + cell_coords_offset.y)
