extends Node2D


enum {
	CORNER,
	SIDEWAY,
	MIDDLE,
	IMMUTABLE,
}


@export_enum("Pattern Picker", "Perlin Noise") var generation_method : int = 0
@export var obstacles_layer : TileMapLayer

@export_group("Chunk Grid")
@export var chunk_size := Vector2i(5, 5)
@export var chunk_grid_padding := Vector2i(1, 1)


var __regular_patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/regular_patterns.res"))
var __middle_patterns : Array[TileMapPattern] = TileMapPatternPacker.unpack(preload("res://tilemap/data/middle_patterns.res"))


var __chunk_grid_map : Array[Array] = [
	[CORNER, SIDEWAY, CORNER],
	[SIDEWAY, MIDDLE, SIDEWAY],
	[CORNER, SIDEWAY, CORNER],
]


func _ready() -> void:
	match generation_method:
		0:
			__fill_chunks_with_patterns()
		1:
			__fill_chunks_with_noise()
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
	return Vector2i(chunk_coords.x * chunk_size.x + chunk_grid_padding.x, chunk_coords.y * chunk_size.y + chunk_grid_padding.y)


func __fill_chunks_with_noise() -> void:
	const OBSTACLE_NOISE_VALUE : float = -0.2
	var perlin_noise : FastNoiseLite = __create_perlin_noise(randi(), 0.350)
	for x in range(chunk_size.x * __chunk_grid_map.size()):
		for y in range(chunk_size.y * __chunk_grid_map.front().size()):
			if perlin_noise.get_noise_2d(x, y) < OBSTACLE_NOISE_VALUE:
				obstacles_layer.set_cell(Vector2i(x + chunk_grid_padding.x, y + chunk_grid_padding.y), 0, Vector2i(0, 1))
	return


func __create_perlin_noise(noise_seed: int, frequency: float = 0.01) -> FastNoiseLite:
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = noise_seed
	noise.frequency = frequency
	return noise
