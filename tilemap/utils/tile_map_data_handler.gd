class_name TileMapDataHandler
extends Object


static func save(data: Array[PackedByteArray], path: String = "") -> Error:
	return ResourceSaver.save(__pack_data(data), path, ResourceSaver.FLAG_COMPRESS)


static func save_from_layers(layers: Array[TileMapLayer], path: String = "") -> Error:
	return ResourceSaver.save(__pack_data(__get_data_from_layers(layers)), path, ResourceSaver.FLAG_COMPRESS)


static func unpack(packed_data: PackedDataContainer) -> Array[PackedByteArray]:
	var data : Array[PackedByteArray]
	for array : Array in packed_data:
		data.append(PackedByteArray(array))
	return data


static func __get_data_from_layers(layers: Array[TileMapLayer]) -> Array[PackedByteArray]:
	var data : Array[PackedByteArray]
	for layer : TileMapLayer in layers:
		data.append(layer.tile_map_data)
	return data


static func __pack_data(data: Array[PackedByteArray]) -> PackedDataContainer:
	var packed_container : PackedDataContainer
	if not data.is_empty():
		packed_container = PackedDataContainer.new()
		if packed_container.pack(data) != OK:
			assert(false, "An error occurred during data packing.")
	return packed_container
