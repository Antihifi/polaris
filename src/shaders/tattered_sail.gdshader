shader_type spatial;
render_mode cull_disabled, depth_draw_always;

// Textures
uniform sampler2D albedo_texture: source_color;
uniform sampler2D normal_texture: hint_normal;
uniform sampler2D wind_noise_texture;
uniform bool use_normal_map = false;

// Material properties
uniform float texture_uv_scale: hint_range(0.1, 10.0) = 1.0;
uniform float roughness: hint_range(0.0, 1.0) = 0.85;
uniform float metallic: hint_range(0.0, 1.0) = 0.0;

// Wind parameters (can override globals for testing)
uniform bool use_global_wind = true;
uniform vec3 local_wind_direction = vec3(1.0, 0.0, 0.0);
uniform float local_wind_intensity: hint_range(0.0, 2.0) = 0.5;
uniform float local_wind_speed: hint_range(0.0, 5.0) = 2.0;

// Wave shape controls
uniform float wave_frequency: hint_range(1.0, 20.0) = 8.0;
uniform float wave_amplitude: hint_range(0.01, 2.0) = 0.3;
uniform float secondary_wave_scale: hint_range(0.0, 1.0) = 0.5;

// Flutter control
uniform bool use_vertex_colors = false;
uniform float flutter_mask_power: hint_range(0.5, 4.0) = 1.5;

// Global wind uniforms (set by WindController)
global uniform vec3 wind_direction;
global uniform float wind_intensity;
global uniform float wind_speed;

varying vec2 texture_uv;

// Unique offset per object so sails don't sync
float get_position_offset(vec3 world_pos) {
	return world_pos.x * 0.17 + world_pos.y * 0.31 + world_pos.z * 0.23;
}

void vertex() {
	texture_uv = UV * texture_uv_scale;

	// Get wind parameters (global or local)
	vec3 wind_dir = use_global_wind ? wind_direction : local_wind_direction;
	float intensity = use_global_wind ? wind_intensity : local_wind_intensity;
	float speed = use_global_wind ? wind_speed : local_wind_speed;

	// Fallback if globals not set
	if (length(wind_dir) < 0.01) {
		wind_dir = local_wind_direction;
		intensity = local_wind_intensity;
		speed = local_wind_speed;
	}

	// Flutter mask
	float flutter_mask;
	if (use_vertex_colors) {
		flutter_mask = COLOR.r;
	} else {
		flutter_mask = pow(UV.y, flutter_mask_power);
	}

	float obj_offset = get_position_offset(NODE_POSITION_WORLD);

	// Primary wave
	float wave_phase = UV.x * wave_frequency - TIME * speed + obj_offset;
	float primary_wave = sin(wave_phase) * wave_amplitude * intensity;

	// Secondary wave
	float secondary_phase = UV.x * wave_frequency * 2.3 + UV.y * 3.0 - TIME * speed * 1.4 + obj_offset * 1.7;
	float secondary_wave = sin(secondary_phase) * wave_amplitude * secondary_wave_scale * intensity;

	// Noise turbulence
	vec2 noise_uv = vec2(
		UV.x * 2.0 + TIME * speed * 0.3 + obj_offset,
		UV.y * 2.0 + TIME * speed * 0.2
	);
	float noise_value = texture(wind_noise_texture, noise_uv).r * 2.0 - 1.0;
	float turbulence = noise_value * wave_amplitude * 0.5 * intensity;

	float total_displacement = (primary_wave + secondary_wave + turbulence) * flutter_mask;

	VERTEX.y += total_displacement;
	VERTEX.x += sin(wave_phase * 0.5) * wave_amplitude * 0.3 * flutter_mask * intensity;
}

void fragment() {
	ALBEDO = texture(albedo_texture, texture_uv).rgb;
	if (use_normal_map) {
		NORMAL_MAP = texture(normal_texture, texture_uv).rgb;
		NORMAL_MAP_DEPTH = 1.0;
	}
	ROUGHNESS = roughness;
	METALLIC = metallic;
}
