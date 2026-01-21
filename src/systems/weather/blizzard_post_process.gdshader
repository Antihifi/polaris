shader_type spatial;
render_mode blend_mix, depth_test_disabled, cull_disabled, unshaded;

// Screen-space volumetric blizzard fog shader
// Adapted from "Frozen Wasteland" by Dave Hoskins (Shadertoy)
// Uses ground-plane projected fog sampling for stable camera movement

// Raymarching settings
uniform int ray_steps : hint_range(8, 64) = 20;
uniform float max_distance : hint_range(50.0, 500.0) = 150.0;

// Fog density and appearance
uniform float fog_density : hint_range(0.0, 0.5) = 0.08;
uniform float fog_height : hint_range(-50.0, 100.0) = 20.0;
uniform float fog_falloff : hint_range(0.0, 0.2) = 0.02;
uniform float fog_thickness : hint_range(1.0, 50.0) = 15.0;

// Noise settings
uniform float noise_scale : hint_range(0.001, 0.05) = 0.004;
uniform float detail_scale : hint_range(0.01, 0.2) = 0.02;

// Wind animation - kept slow and smooth
uniform float wind_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wind_direction : hint_range(-3.14159, 3.14159) = 0.0;
uniform float vertical_drift : hint_range(0.0, 1.0) = 0.1;

// Wave turbulence for organic band shapes
uniform float wave_amplitude : hint_range(0.0, 30.0) = 15.0;
uniform float wave_frequency : hint_range(0.0, 0.2) = 0.04;

// Colors
uniform vec3 fog_color : source_color = vec3(0.8, 0.82, 0.85);
uniform vec3 fog_emission : source_color = vec3(0.05, 0.05, 0.06);

// Light scattering tint (set from Sky3D sun color for sunrise/sunset matching)
uniform vec3 light_tint : source_color = vec3(1.0, 1.0, 1.0);
uniform float light_tint_strength : hint_range(0.0, 1.0) = 0.5;

// Depth texture for scene occlusion
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

// Triangle wave - creates sharper patterns than sine
float tri(float x) {
	return abs(fract(x) - 0.5);
}

// 3D triangle function for noise perturbation
vec3 tri3(vec3 p) {
	return vec3(
		tri(p.z + tri(p.y)),
		tri(p.z + tri(p.x)),
		tri(p.y + tri(p.x))
	);
}

// Layered triangle noise - sharp, defined bands
// Based on Dave Hoskins' technique from "Frozen Wasteland"
float triangle_noise_3d(vec3 p) {
	float z = 1.4;
	float rz = 0.0;
	vec3 bp = p;

	for (int i = 0; i < 3; i++) {
		vec3 dg = tri3(bp);
		p += dg;
		bp *= 2.0;
		z *= 1.5;
		p *= 1.3;
		rz += tri(p.z + tri(p.x + tri(p.y))) / z;
		bp += 0.14;
	}
	return rz;
}

// Sample fog density using WORLD XZ coordinates only
// This ensures fog bands are anchored to the world and don't swirl with camera movement
float sample_fog_2d(vec2 world_xz, float world_y, float time_val) {
	// Wind direction vector
	vec2 wind_dir = vec2(-sin(wind_direction), -cos(wind_direction));

	// Animate fog position with wind (XZ plane only)
	vec2 fog_xz = world_xz;
	fog_xz -= time_val * wind_speed * wind_dir;

	// Add large sweeping waves for organic band movement
	// These are based on original world position, not animated position
	fog_xz.x += sin(world_xz.y * wave_frequency + time_val * 0.15) * wave_amplitude;
	fog_xz.y += cos(world_xz.x * wave_frequency * 0.8 + time_val * 0.1) * wave_amplitude * 0.7;

	// Sample noise using 2D position + slow vertical animation
	vec3 noise_pos = vec3(fog_xz.x, time_val * vertical_drift, fog_xz.y);

	// Primary noise at coarse scale for main bands
	float noise = triangle_noise_3d(noise_pos * noise_scale);

	// Detail noise at finer scale
	float detail = triangle_noise_3d(noise_pos * detail_scale) * 0.25;

	// Combine
	noise = noise * 0.75 + detail;

	// Threshold to create distinct bands with gaps
	noise = smoothstep(0.2, 0.5, noise);

	// Height-based density - fog is thickest near fog_height, fades above and below
	float height_dist = abs(world_y - fog_height);
	float height_factor = exp(-height_dist * fog_falloff);

	// Also fade with horizontal distance for volume effect
	return noise * height_factor;
}

varying mat4 inv_proj;
varying mat4 cam_matrix;

void vertex() {
	// Fullscreen quad positioning
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	inv_proj = INV_PROJECTION_MATRIX;
	cam_matrix = INV_VIEW_MATRIX;
}

void fragment() {
	// Get depth and reconstruct world position
	float depth_raw = texture(DEPTH_TEXTURE, SCREEN_UV).r;

	// Convert depth to view space position
	vec4 ndc = vec4(SCREEN_UV * 2.0 - 1.0, depth_raw, 1.0);
	vec4 view_pos = inv_proj * ndc;
	view_pos.xyz /= view_pos.w;

	// Convert to world position
	vec4 world_pos = cam_matrix * vec4(view_pos.xyz, 1.0);
	vec3 scene_pos = world_pos.xyz;

	// Camera position in world space
	vec3 cam_pos = (cam_matrix * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

	// Ray direction
	vec3 ray_dir = normalize(scene_pos - cam_pos);

	// Distance to scene geometry
	float scene_dist = length(scene_pos - cam_pos);

	// Limit ray distance
	float ray_max = min(scene_dist, max_distance);

	// Raymarching with Beer-Lambert transmittance
	float transmittance = 1.0;
	float step_size = ray_max / float(ray_steps);

	for (int i = 0; i < ray_steps; i++) {
		// Sample at fixed intervals along ray
		float t = (float(i) + 0.5) * step_size;
		vec3 sample_pos = cam_pos + ray_dir * t;

		// KEY: Sample fog using only XZ world coordinates
		// This makes fog bands stable regardless of camera position/angle
		float fog_sample = sample_fog_2d(sample_pos.xz, sample_pos.y, TIME);

		// Beer-Lambert transmittance
		transmittance *= exp(-fog_sample * fog_density * step_size);

		// Early exit optimization
		if (transmittance < 0.01) break;
	}

	// Convert transmittance to opacity
	float opacity = 1.0 - transmittance;

	// Cap maximum opacity to prevent whiteout
	opacity = min(opacity, 0.7);

	// Apply light tint for sunrise/sunset
	vec3 tinted_fog = mix(fog_color, fog_color * light_tint, light_tint_strength);

	// Output
	ALBEDO = tinted_fog + fog_emission;
	ALPHA = opacity;
}
