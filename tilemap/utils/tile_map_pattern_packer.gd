class_name TileMapPatternPacker
extends Object


static func pack(patterns: Array[TileMapPattern]) -> PackedDataContainer:
	var packed_patterns : Array[PackedByteArray]
	for pattern : TileMapPattern in patterns:
		packed_patterns.append(var_to_bytes_with_objects(pattern))
	
	var packed_container : PackedDataContainer
	if not packed_patterns.is_empty():
		packed_container = PackedDataContainer.new()
		var result : Error = packed_container.pack(packed_patterns)
		if result != OK:
			assert(false, "An error occurred during data packing. Error code: %s" % result)
		
	return packed_container


static func unpack(packed_data: PackedDataContainer) -> Array[TileMapPattern]:
	var patterns : Array[TileMapPattern]
	for pattern : Array in packed_data:
		patterns.append(bytes_to_var_with_objects(pattern))
	return patterns


static func save(packed_data: PackedDataContainer, path: String = "") -> Error:
	return ResourceSaver.save(packed_data, path, ResourceSaver.FLAG_COMPRESS)


static func save_single_pattern(pattern: TileMapPattern, path: String = "") -> Error:
	return ResourceSaver.save(pattern, path, ResourceSaver.FLAG_COMPRESS)
