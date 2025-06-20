extends Node2D


@export var preset_layers : PackedScene


var __obstacle_layers : Array[TileMapLayer]


func _ready() -> void:
	__obstacle_layers.assign($ObstacleLayers.get_children())
	if not __obstacle_layers.is_empty():
		__generate_level()
	return


func __generate_level() -> void:
	var presets : Array[TileMapLayer]
	presets.assign(preset_layers.instantiate().get_children())
	
	for layer : TileMapLayer in __obstacle_layers:
		var preset_layer : TileMapLayer
		while true:
			preset_layer = presets.pick_random()
			# CRITICAL: If there is no preset of the required size, the program will never leave this loop.
			if layer.get_used_rect().size >= preset_layer.get_used_rect().size:
				break
		__set_chunk(preset_layer, layer)
	
	return


func __set_chunk(from: TileMapLayer, to: TileMapLayer) -> void:
	var origin_layer_size : Vector2i = from.get_used_rect().size
	var origin_layer_cells : Array[Vector2i] = from.get_used_cells()
	for x in range(origin_layer_size.x):
		for y in range(origin_layer_size.y):
			var target_cell := Vector2i(x, y) + to.get_used_rect().position
			var origin_cell := Vector2i(x, y) + from.get_used_rect().position
			if origin_layer_cells.has(origin_cell):
				to.set_cell(target_cell, from.get_cell_source_id(origin_cell), from.get_cell_atlas_coords(origin_cell))
			else:
				to.erase_cell(target_cell)
	return
