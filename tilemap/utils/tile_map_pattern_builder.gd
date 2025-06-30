class_name TileMapPatternBuilder
extends RefCounted


var chunk_size : Vector2i:
	get:
		return chunk_size
	set(value):
		chunk_size = value
		return
var tile_map_layer : TileMapLayer:
	get:
		return tile_map_layer
	set(value):
		tile_map_layer = value
		return


func _init(p_chunk_size: Vector2i, p_tile_map_layer: TileMapLayer) -> void:
	chunk_size = p_chunk_size
	tile_map_layer = p_tile_map_layer
	return


func get_patterns_from_chunks() -> Array[TileMapPattern]:
	var patterns : Array[TileMapPattern]
	var presets_grid_size : Vector2i = __get_chunk_grid_size()
	for row in range(presets_grid_size.x):
		for col in range(presets_grid_size.y):
			var cells : Array[Vector2i] = __get_cells_on_chunk(Vector2i(row, col))
			if not __is_all_cells_empty(cells):
				patterns.append(tile_map_layer.get_pattern(cells))
	return patterns


func __get_chunk_grid_size() -> Vector2i:
	var rect_sizef : Vector2 = tile_map_layer.get_used_rect().size
	return Vector2i(ceili(rect_sizef.x / chunk_size.x), ceili(rect_sizef.y / chunk_size.y))


func __get_cells_on_chunk(chunk_coords: Vector2i) -> Array[Vector2i]:
	var cells : Array[Vector2i]
	var cell_coords_offset := Vector2i(chunk_coords.x * chunk_size.x, chunk_coords.y * chunk_size.y)
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			cells.append(Vector2i(x + cell_coords_offset.x, y + cell_coords_offset.y))
	return cells


func __is_all_cells_empty(cells: Array[Vector2i]) -> bool:
	var result : bool = true
	var used_cells : Array[Vector2i] = tile_map_layer.get_used_cells()
	for cell : Vector2i in cells:
		if used_cells.has(cell):
			result = false
			break
	return result
