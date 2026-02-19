#[compute]
#version 450

// GPU Compute Shader for Hydraulic Erosion
// Port of Clay John's Shadertoy algorithm (MIT License)
// https://www.shadertoy.com/view/7ljcRW
//
// Processes terrain heightmap in parallel - each thread handles one pixel.
// Creates branching channel networks by accumulating directional noise along slopes.

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

// Input heightmap (read-only, FORMAT_RF)
layout(set = 0, binding = 0, r32f) uniform readonly image2D input_heightmap;
// Output heightmap (write-only, FORMAT_RF)
layout(set = 0, binding = 1, r32f) uniform writeonly image2D output_heightmap;
// Island mask (read-only, FORMAT_RF)
layout(set = 0, binding = 2, r32f) uniform readonly image2D island_mask;

// Parameters passed from GDScript (48 bytes, 16-byte aligned)
layout(push_constant) uniform Params {
	float erosion_tiles;
	float erosion_octaves;
	float erosion_gain;
	float erosion_lacunarity;
	float erosion_slope_strength;
	float erosion_branch_strength;
	float erosion_strength;
	float height_range;
	float meters_per_pixel;  // world-space size of each pixel
	int width;
	int height;
	int _padding;  // Pad to 48 bytes for 16-byte alignment
} params;

// Hash function for deterministic pseudo-random values
// Returns vec2 in range [-1, 1]
vec2 hash2(vec2 p) {
	vec2 k = vec2(0.3183099, 0.3678794);
	vec2 x = vec2(p.x * k.x + k.y, p.y * k.y + k.x);
	float dot_val = x.x * x.y * (x.x + x.y);
	float frac_val = fract(dot_val);
	float result = fract(16.0 * k.x * frac_val);
	float result2 = fract(result * 1.3847);
	return vec2(-1.0 + 2.0 * result, -1.0 + 2.0 * result2);
}

// Core erosion noise function - directional noise that follows flow direction
// This is THE key function that creates the branching channel effect
// Returns vec3(height, gradient.x, gradient.y)
vec3 erosion_noise(vec2 p, vec2 flow_dir) {
	vec2 ip = floor(p);
	vec2 fp = fract(p);
	float f = 2.0 * 3.14159265;

	vec3 va = vec3(0.0);
	float wt = 0.0;

	// Sample 4x4 kernel around the point
	for (int j = -2; j < 2; j++) {
		for (int i = -2; i < 2; i++) {
			vec2 o = vec2(float(i), float(j));
			vec2 h = hash2(ip - o) * 0.5;
			vec2 pp = fp + o - h;
			float d = dot(pp, pp);
			float w = exp(-d * 2.0);
			wt += w;

			// Directional influence - noise aligned with flow direction
			float mag = dot(pp, flow_dir);
			float cos_val = cos(mag * f);
			float sin_val = -sin(mag * f);

			va.x += cos_val * w;
			va.y += sin_val * flow_dir.x * w;
			va.z += sin_val * flow_dir.y * w;
		}
	}

	return wt > 0.0 ? va / wt : vec3(0.0);
}

void main() {
	ivec2 pos = ivec2(gl_GlobalInvocationID.xy);

	// Bounds check
	if (pos.x >= params.width || pos.y >= params.height) return;

	// Edge pixels: copy unchanged (need neighbors for gradient)
	if (pos.x < 2 || pos.y < 2 || pos.x >= params.width - 2 || pos.y >= params.height - 2) {
		float h = imageLoad(input_heightmap, pos).r;
		imageStore(output_heightmap, pos, vec4(h, 0.0, 0.0, 1.0));
		return;
	}

	// Check island mask - skip ocean/ice
	float mask_val = imageLoad(island_mask, pos).r;
	if (mask_val < 0.2) {
		float h = imageLoad(input_heightmap, pos).r;
		imageStore(output_heightmap, pos, vec4(h, 0.0, 0.0, 1.0));
		return;
	}

	float current_h = imageLoad(input_heightmap, pos).r;

	// Compute terrain gradient (slope direction) in world-space units
	// Divide by meters_per_pixel to get proper slope (meters rise / meters run)
	float h_left = imageLoad(input_heightmap, pos + ivec2(-1, 0)).r;
	float h_right = imageLoad(input_heightmap, pos + ivec2(1, 0)).r;
	float h_up = imageLoad(input_heightmap, pos + ivec2(0, -1)).r;
	float h_down = imageLoad(input_heightmap, pos + ivec2(0, 1)).r;
	vec2 terrain_grad = vec2(
		(h_right - h_left) * 0.5 / params.meters_per_pixel,
		(h_down - h_up) * 0.5 / params.meters_per_pixel
	);

	// Normalized UV coordinates [0, 1]
	vec2 uv = vec2(float(pos.x) / float(params.width), float(pos.y) / float(params.height));

	// === EROSION FBM ===
	// Start with slope direction (curl/perpendicular gives flow direction)
	vec2 flow_dir = vec2(terrain_grad.y, -terrain_grad.x) * params.erosion_slope_strength;

	vec3 h = vec3(0.0);  // Accumulated (height, grad.x, grad.y)
	float amplitude = 0.5;
	float frequency = 1.0;

	int octaves = int(params.erosion_octaves);
	for (int o = 0; o < octaves; o++) {
		vec2 sample_pos = uv * params.erosion_tiles * frequency;

		// KEY: flow_dir is modified by previous octave's gradient
		// This creates the branching effect!
		vec3 erosion_sample = erosion_noise(
			sample_pos,
			flow_dir + vec2(h.y, h.z) * params.erosion_branch_strength
		);

		// Accumulate with proper scaling
		h.x += erosion_sample.x * amplitude;
		h.y += erosion_sample.y * amplitude * frequency;
		h.z += erosion_sample.z * amplitude * frequency;

		amplitude *= params.erosion_gain;
		frequency *= params.erosion_lacunarity;
	}

	// Apply erosion: centered around 0.5, so (h.x - 0.5) gives displacement
	float erosion_displacement = (h.x - 0.5) * params.erosion_strength * params.height_range;

	// Reduce erosion in flat areas (preserve walkable terrain)
	float slope_mag = length(terrain_grad);
	float slope_factor = clamp(slope_mag / 10.0, 0.1, 1.0);
	erosion_displacement *= slope_factor;

	// Reduce erosion at island edges (preserve coastline shape)
	float edge_factor = clamp((mask_val - 0.2) / 0.3, 0.0, 1.0);
	erosion_displacement *= edge_factor;

	float new_h = current_h + erosion_displacement;
	imageStore(output_heightmap, pos, vec4(new_h, 0.0, 0.0, 1.0));
}
