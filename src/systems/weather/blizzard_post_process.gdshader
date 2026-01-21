shader_type spatial;
render_mode blend_mix, depth_test_disabled, cull_disabled, unshaded;

// Screen-space volumetric blizzard fog shader
// Adapted from "Frozen Wasteland" by Dave Hoskins (Shadertoy)
// Uses full 3D world-space fog sampling with wind animation

// Raymarching settings
uniform int ray_steps : hint_range(8, 64) = 24;
uniform float max_distance : hint_range(50.0, 500.0) = 150.0;

// Fog density and appearance
uniform float fog_density : hint_range(0.0, 0.5) = 0.08;
uniform float fog_height : hint_range(-50.0, 100.0) = 20.0;
uniform float fog_falloff : hint_range(0.0, 0.2) = 0.04;

// Noise settings
uniform float noise_scale : hint_range(0.001, 0.05) = 0.008;
uniform float detail_scale : hint_range(0.01, 0.2) = 0.03;

// Wind animation
uniform float wind_speed : hint_range(0.0, 20.0) = 7.0;
uniform float wind_direction : hint_range(-3.14159, 3.14159) = 0.0;
uniform float vertical_drift : hint_range(0.0, 3.0) = 0.5;

// Wave turbulence for organic band shapes
uniform float wave_amplitude : hint_range(0.0, 10.0) = 3.0;
uniform float wave_frequency : hint_range(0.0, 1.0) = 0.3;

// Maximum fog opacity (prevents whiteout)
uniform float fog_max_opacity : hint_range(0.1, 1.0) = 0.7;

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

// Sample fog density at a 3D world position
// Uses full 3D noise sampling with wind animation - like original Shadertoy
float fogmap(vec3 world_pos, float time_val) {
	vec3 p = world_pos;

	// Wind direction vector (negated to match particle visual direction)
	vec2 wind_dir = vec2(-sin(wind_direction), -cos(wind_direction));

	// Horizontal wind drift - fog moves with the wind
	p.xz -= time_val * wind_speed * wind_dir;

	// Add wave turbulence for organic movement
	// Use original world position for wave offset so bands sweep across terrain
	p.xz += sin(world_pos.z * wave_frequency) * wave_amplitude;
	p.xz += cos(world_pos.x * wave_frequency * 0.7) * wave_amplitude * 0.5;

	// Vertical falling motion (snow/fog settling downward)
	p.y -= time_val * vertical_drift;

	// Primary triangle noise - creates defined bands
	float noise = triangle_noise_3d(p * noise_scale + 0.1);

	// Detail layer at finer scale for texture
	float detail = triangle_noise_3d(p * detail_scale) * 0.3;

	// Combine with threshold for gaps between bands
	// max(noise - threshold, 0) creates areas of zero fog
	float combined = max(noise - 0.1, 0.0) * (noise * 0.7 + detail);

	// Height-based density - fog is thickest below fog_height, fades above
	float height_factor = 1.0;
	if (world_pos.y > fog_height) {
		height_factor = exp(-(world_pos.y - fog_height) * fog_falloff);
	}

	return combined * height_factor;
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

	// Raymarching - accumulate fog along the ray
	float fog_amount = 0.0;
	float step_size = ray_max / float(ray_steps);

	for (int i = 0; i < ray_steps; i++) {
		// Sample at fixed intervals along ray
		float t = (float(i) + 0.5) * step_size;
		vec3 sample_pos = cam_pos + ray_dir * t;

		// Sample fog at full 3D world position
		float fog_sample = fogmap(sample_pos, TIME);

		// Accumulate fog with distance-based density
		fog_amount += fog_sample * fog_density * step_size;

		// Early exit optimization
		if (fog_amount > 0.95) break;
	}

	// Apply max opacity cap to prevent whiteout
	float opacity = min(fog_amount, fog_max_opacity);

	// Apply light tint for sunrise/sunset
	vec3 tinted_fog = mix(fog_color, fog_color * light_tint, light_tint_strength);

	// Output
	ALBEDO = tinted_fog + fog_emission;
	ALPHA = opacity;
}
