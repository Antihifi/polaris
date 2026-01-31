shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform float speed : hint_range(0.001, 0.1) = 0.01;
uniform vec4 color : source_color = vec4(0.15, 0.85, 0.45, 1.0);
uniform float emission_strength : hint_range(0.0, 20.0) = 4.0;
uniform sampler2D noise;
uniform float offset : hint_range(-1.0, 1.0) = 0.0;
uniform float smoothness : hint_range(0.01, 0.5) = 0.15;
uniform float distort : hint_range(0.0, 5.0) = 1.0;
uniform float scale : hint_range(0.001, 0.1) = 0.02;

// Controller-driven uniforms
uniform float intensity : hint_range(0.0, 1.0) = 1.0;
uniform float speed_multiplier : hint_range(0.0, 5.0) = 1.0;

group_uniforms Raymarching;
uniform float STEP : hint_range(0.005, 0.1) = 0.02;
uniform float BASE_DENSITY : hint_range(0.1, 10.0) = 2.0;

varying vec3 camera_position;
varying vec3 vertex_position;

float amplify(float value) {
	float magic_number = 0.166504;
	float output = 0.0;
	value = clamp(value, 0.0, 1.0);
	value = pow(value, 2.0);
	output += pow(magic_number, 4.0) * value;
	value = pow(value, 2.0);
	output += magic_number * value;
	value = pow(value, 2.0);
	output += value;
	return output;
}

float interpolate_noise(vec2 uv1, vec2 uv2) {
	return smoothstep(
		-smoothness, smoothness, texture(noise, uv1).r - texture(noise, uv2).r
	);
}

float random_wave(vec2 uv) {
	float t = TIME * speed * speed_multiplier;
	vec2 uv_distort = texture(noise, uv).rr * distort * 0.5;
	vec2 uv1 = uv * scale + vec2(t, t - offset) + uv_distort;
	vec2 uv2 = uv * scale + vec2(t + 0.5, t + offset) + uv_distort;
	float interpolated_noise = interpolate_noise(uv1, uv2);
	float wave_intensity = 0.2 + clamp((0.5 - abs(interpolated_noise - 0.5)) * 1.5, 0.0, 1.0);
	float wave = amplify(wave_intensity);
	return wave;
}

float ray_march(vec3 ray_origin, vec3 ray_direction, float start) {
	float density = 0.0;
	float dist = start + STEP;

	while (true) {
		vec3 point = ray_origin + ray_direction * dist;
		if (clamp(point, vec3(-1.0, -1.0, -1.0), vec3(1.0, 1.0, 1.0)) != point) {
			break;
		}
		vec2 uv = vec2((point.x + 1.0) * 0.5, (point.z + 1.0) * 0.5);
		float wave_value = random_wave(uv);
		float height_factor = (1.0 - point.y) * 0.5;

		// Soft edge fade to hide box boundaries
		float edge_fade = smoothstep(-1.0, -0.6, point.x) * smoothstep(1.0, 0.6, point.x)
		               * smoothstep(-1.0, -0.6, point.z) * smoothstep(1.0, 0.6, point.z);

		float point_density = BASE_DENSITY * STEP * height_factor * wave_value * edge_fade;
		density += point_density;
		dist += STEP;
	}

	return density;
}

void vertex() {
	vertex_position = VERTEX;
	camera_position = (inverse(MODELVIEW_MATRIX) * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
}

void fragment() {
	vec3 ray_origin = camera_position;
	vec3 ray_direction = normalize(vertex_position - ray_origin);

	// If camera is inside the [-1,1] volume, start raymarching from the camera (dist=0).
	// If outside, start from the mesh surface (original behavior).
	vec3 clamped_cam = clamp(camera_position, vec3(-1.0), vec3(1.0));
	float cam_dist_to_bounds = length(clamped_cam - camera_position);
	float start_dist = cam_dist_to_bounds < 0.01 ? 0.0 : length(camera_position - vertex_position);

	float density = ray_march(ray_origin, ray_direction, start_dist);

	float final_density = density * intensity;
	ALBEDO = color.rgb * final_density;
	EMISSION = color.rgb * final_density * emission_strength;
	ALPHA = final_density;
}
