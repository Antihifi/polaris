shader_type fog;

// Animated blizzard fog shader - creates drifting snow/wind bands
// Based on sandstorm shader, adapted for arctic blizzard
// Wind direction syncs with Sky3D wind for consistent particle/fog movement

uniform sampler2D noise_tex : repeat_enable;
uniform float noise_scale : hint_range(0.0, 1.0, 0.0001) = 0.02;
uniform float flatness : hint_range(0.0, 50.0, 0.1) = 8.0;
uniform float density : hint_range(0.0, 6.0, 0.0001) = 2.0;
uniform sampler2D grad_tex;
uniform vec3 emission : source_color = vec3(0.7, 0.7, 0.75);
uniform float fog_speed : hint_range(-5.0, 5.0, 0.001) = 0.8;
// Wind direction in radians (0 = north, synced from Sky3D)
uniform float wind_direction : hint_range(-3.14159, 3.14159) = 0.0;

void fog() {
	// Calculate wind vector from direction
	// Negated to match particle visual direction (particles spawn upwind and drift toward camera)
	vec2 wind_dir = vec2(-sin(wind_direction), -cos(wind_direction));
	vec2 move_uv = wind_dir * TIME * fog_speed;

	float detail_noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv * 0.5).r;
	float noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv + detail_noise).r;
	DENSITY = mix(1.0, noise, UVW.y * flatness);
	DENSITY *= step(0.0, -SDF) * density;
	vec3 col = texture(grad_tex, vec2(DENSITY, 0.5)).rgb;
	ALBEDO = col;
	EMISSION = emission;
}
