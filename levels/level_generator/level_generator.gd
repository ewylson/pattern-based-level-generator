extends Node2D


enum {
	CORNER,
	SIDEWAY,
	MIDDLE,
	IMMUTABLE,
}


@export var obstacles_layer : TileMapLayer

@export_group("Chunk Grid")
@export var chunk_size := Vector2i(5, 5)
@export var chunk_grid_padding := Vector2i(2, 2)


var __regular_patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/regular_patterns.res"))
var __middle_patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/middle_patterns.res"))


var __chunk_grid_map : Array[Array] = [
	[CORNER, SIDEWAY, CORNER],
	[SIDEWAY, MIDDLE, SIDEWAY],
	[CORNER, SIDEWAY, CORNER],
]


func _ready() -> void:
	__fill_chunks_with_patterns()
	return


func __fill_chunks_with_patterns() -> void:
	for start_cell : Vector2i in __get_chunk_start_cells([CORNER, SIDEWAY]):
		obstacles_layer.set_pattern(start_cell, __regular_patterns.pick_random())
	for start_cell : Vector2i in __get_chunk_start_cells([MIDDLE]):
		obstacles_layer.set_pattern(start_cell, __middle_patterns.pick_random())
	return


func __get_chunk_start_cells(chunk_types: Array[int]) -> Array[Vector2i]:
	var chunk_start_cells : Array[Vector2i]
	for row in range(__chunk_grid_map.size()):
		for col in range(__chunk_grid_map[row].size()):
			if __is_proper_chunk(__chunk_grid_map[row][col], chunk_types):
				chunk_start_cells.append(__get_start_cell_on_chunk(Vector2i(col, row)))
	return chunk_start_cells


func __is_proper_chunk(chunk: int, chunk_types: Array[int]) -> bool:
	var result : bool = false
	for type : int in chunk_types:
		if chunk == type:
			result = true
			break
	return result


func __get_start_cell_on_chunk(chunk_coords: Vector2i) -> Vector2i:
	var cell_coords_offset : Vector2i = chunk_grid_padding / 2
	return Vector2i(chunk_coords.x * chunk_size.x + cell_coords_offset.x, chunk_coords.y * chunk_size.y + cell_coords_offset.y)
