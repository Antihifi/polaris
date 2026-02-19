class_name GPUErosion
extends RefCounted
## GPU Compute Shader wrapper for hydraulic erosion.
## Uses Godot 4.5 RenderingDevice API for parallel processing.
## Falls back to CPU if GPU not available.


## Apply hydraulic erosion using GPU compute shader.
## Much faster than CPU for large maps (2048x2048+).
## meters_per_pixel: world-space size of each pixel (for proper gradient scaling)
static func apply_hydraulic_erosion_gpu(
	heightmap: Image,
	island_mask: Image,
	config: Resource = null,
	meters_per_pixel: float = 1.0
) -> void:
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	print("[GPUErosion] Starting GPU erosion for %dx%d heightmap..." % [width, height])
	var start_time := Time.get_ticks_msec()

	# Create local rendering device for compute
	var rd := RenderingServer.create_local_rendering_device()
	if rd == null:
		push_warning("[GPUErosion] GPU not available, falling back to CPU erosion")
		# For fallback, use smaller resolution or reduced quality
		_cpu_erosion_fallback(heightmap, island_mask, config)
		return

	# Load and compile shader
	var shader_file := load("res://shaders/hydraulic_erosion.glsl")
	if shader_file == null:
		push_error("[GPUErosion] Failed to load shader file")
		rd.free()
		return

	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	if shader_spirv == null:
		push_error("[GPUErosion] Failed to get SPIRV from shader")
		rd.free()
		return

	var shader := rd.shader_create_from_spirv(shader_spirv)
	if not shader.is_valid():
		push_error("[GPUErosion] Failed to create shader from SPIRV")
		rd.free()
		return

	# Ensure heightmap is in correct format (FORMAT_RF = single-channel float)
	if heightmap.get_format() != Image.FORMAT_RF:
		heightmap.convert(Image.FORMAT_RF)
	if island_mask.get_format() != Image.FORMAT_RF:
		island_mask.convert(Image.FORMAT_RF)

	# Create textures
	var input_tex := _create_texture_from_image(rd, heightmap, true)
	var output_tex := _create_output_texture(rd, width, height)
	var mask_tex := _create_texture_from_image(rd, island_mask, true)

	if not input_tex.is_valid() or not output_tex.is_valid() or not mask_tex.is_valid():
		push_error("[GPUErosion] Failed to create textures")
		_cleanup(rd, shader, input_tex, output_tex, mask_tex, RID(), RID())
		return

	# Create uniforms
	var input_uniform := RDUniform.new()
	input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	input_uniform.binding = 0
	input_uniform.add_id(input_tex)

	var output_uniform := RDUniform.new()
	output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	output_uniform.binding = 1
	output_uniform.add_id(output_tex)

	var mask_uniform := RDUniform.new()
	mask_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	mask_uniform.binding = 2
	mask_uniform.add_id(mask_tex)

	var uniform_set := rd.uniform_set_create([input_uniform, output_uniform, mask_uniform], shader, 0)
	if not uniform_set.is_valid():
		push_error("[GPUErosion] Failed to create uniform set")
		_cleanup(rd, shader, input_tex, output_tex, mask_tex, RID(), RID())
		return

	# Prepare push constants
	var height_range := _get_height_range(heightmap)
	var params := PackedFloat32Array([
		config.erosion_tiles if config and "erosion_tiles" in config else 4.0,
		float(config.erosion_octaves if config and "erosion_octaves" in config else 5),
		config.erosion_gain if config and "erosion_gain" in config else 0.5,
		config.erosion_lacunarity if config and "erosion_lacunarity" in config else 2.0,
		config.erosion_slope_strength if config and "erosion_slope_strength" in config else 3.0,
		config.erosion_branch_strength if config and "erosion_branch_strength" in config else 3.0,
		config.erosion_strength if config and "erosion_strength" in config else 0.04,
		height_range,
		meters_per_pixel,  # world-space pixel size for gradient scaling
	])

	# Convert to bytes and add int params (48 bytes total for 16-byte alignment)
	var params_bytes := params.to_byte_array()
	params_bytes.append_array(PackedInt32Array([width, height, 0]).to_byte_array())  # width, height, padding

	print("[GPUErosion]   tiles=%.1f, octaves=%d, strength=%.3f, height_range=%.1f, meters_per_pixel=%.2f" % [
		params[0], int(params[1]), params[6], height_range, meters_per_pixel
	])

	# Create compute pipeline
	var pipeline := rd.compute_pipeline_create(shader)
	if not pipeline.is_valid():
		push_error("[GPUErosion] Failed to create compute pipeline")
		_cleanup(rd, shader, input_tex, output_tex, mask_tex, uniform_set, RID())
		return

	# Dispatch compute shader
	var x_groups := ceili(float(width) / 16.0)
	var y_groups := ceili(float(height) / 16.0)

	var compute_list := rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_set_push_constant(compute_list, params_bytes, params_bytes.size())
	rd.compute_list_dispatch(compute_list, x_groups, y_groups, 1)
	rd.compute_list_end()

	# Submit and wait for completion
	rd.submit()
	rd.sync()

	# Read back result
	var output_data := rd.texture_get_data(output_tex, 0)
	if output_data.size() != width * height * 4:  # 4 bytes per float
		push_error("[GPUErosion] Output data size mismatch: expected %d, got %d" % [
			width * height * 4, output_data.size()
		])
		_cleanup(rd, shader, input_tex, output_tex, mask_tex, uniform_set, pipeline)
		return

	# Create result image and copy to heightmap
	var result_image := Image.create_from_data(width, height, false, Image.FORMAT_RF, output_data)
	heightmap.copy_from(result_image)

	# Cleanup
	_cleanup(rd, shader, input_tex, output_tex, mask_tex, uniform_set, pipeline)

	var elapsed := Time.get_ticks_msec() - start_time
	print("[GPUErosion] GPU erosion complete in %dms" % elapsed)


static func _create_texture_from_image(rd: RenderingDevice, image: Image, read_only: bool) -> RID:
	var fmt := RDTextureFormat.new()
	fmt.width = image.get_width()
	fmt.height = image.get_height()
	fmt.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	fmt.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
	if not read_only:
		fmt.usage_bits |= RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT

	var view := RDTextureView.new()
	return rd.texture_create(fmt, view, [image.get_data()])


static func _create_output_texture(rd: RenderingDevice, width: int, height: int) -> RID:
	var fmt := RDTextureFormat.new()
	fmt.width = width
	fmt.height = height
	fmt.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	fmt.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT

	var view := RDTextureView.new()
	return rd.texture_create(fmt, view)


static func _get_height_range(heightmap: Image) -> float:
	var min_h := INF
	var max_h := -INF
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	# Sample every 16th pixel for speed (still accurate enough)
	for y in range(0, height, 16):
		for x in range(0, width, 16):
			var h: float = heightmap.get_pixel(x, y).r
			min_h = minf(min_h, h)
			max_h = maxf(max_h, h)

	return maxf(max_h - min_h, 1.0)


static func _cleanup(
	rd: RenderingDevice,
	shader: RID,
	input_tex: RID,
	output_tex: RID,
	mask_tex: RID,
	uniform_set: RID,
	pipeline: RID
) -> void:
	if pipeline.is_valid():
		rd.free_rid(pipeline)
	if uniform_set.is_valid():
		rd.free_rid(uniform_set)
	if input_tex.is_valid():
		rd.free_rid(input_tex)
	if output_tex.is_valid():
		rd.free_rid(output_tex)
	if mask_tex.is_valid():
		rd.free_rid(mask_tex)
	if shader.is_valid():
		rd.free_rid(shader)
	rd.free()


static func _cpu_erosion_fallback(heightmap: Image, island_mask: Image, config: Resource) -> void:
	## Fallback: run CPU erosion at reduced resolution
	var width := heightmap.get_width()
	var height := heightmap.get_height()

	if width <= 512:
		# Small enough for CPU
		var rng := RandomNumberGenerator.new()
		rng.seed = 12345
		HeightmapGenerator.apply_hydraulic_erosion(heightmap, island_mask, rng, config)
	else:
		# Skip erosion entirely for very large maps without GPU
		print("[GPUErosion] No GPU available and map too large for CPU - skipping erosion")
