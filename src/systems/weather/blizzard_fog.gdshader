shader_type fog;

// Volumetric blizzard fog shader - creates drifting snow/wind bands
// Adapted from "Frozen Wasteland" by Dave Hoskins (Shadertoy)
// Uses triangle noise for sharp, defined bands instead of smooth Perlin
// Wind direction syncs with Sky3D wind for consistent particle/fog movement

// Noise and density controls
uniform float noise_scale : hint_range(0.001, 0.1, 0.001) = 0.008;
uniform float density : hint_range(0.0, 5.0, 0.1) = 1.5;
uniform float max_opacity : hint_range(0.0, 1.0, 0.05) = 0.7;

// Wind animation
uniform float wind_speed : hint_range(0.0, 20.0, 0.5) = 7.0;
uniform float wind_direction : hint_range(-3.14159, 3.14159) = 0.0;
uniform float vertical_drift : hint_range(0.0, 3.0, 0.1) = 0.5;

// Wave parameters for organic movement
uniform float wave_amplitude : hint_range(0.0, 10.0, 0.5) = 3.0;
uniform float wave_frequency : hint_range(0.0, 1.0, 0.05) = 0.3;

// Colors
uniform vec3 fog_albedo : source_color = vec3(0.75, 0.77, 0.8);
uniform vec3 emission : source_color = vec3(0.6, 0.62, 0.65);

// Triangle wave function - creates sharper patterns than sine
float tri(float x) {
	return abs(fract(x) - 0.5);
}

// 3D triangle function for noise offset
vec3 tri3(vec3 p) {
	return vec3(
		tri(p.z + tri(p.y)),
		tri(p.z + tri(p.x)),
		tri(p.y + tri(p.x))
	);
}

// Layered triangle noise - creates sharp, defined bands
// Based on Dave Hoskins' technique from "Frozen Wasteland"
float triangle_noise_3d(vec3 p) {
	float z = 1.4;
	float rz = 0.0;
	vec3 bp = p;

	// 3 octaves of layered triangle noise
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

void fog() {
	// Calculate wind vector from direction
	// Negated to match particle visual direction (particles spawn upwind and drift toward camera)
	vec2 wind_dir = vec2(-sin(wind_direction), -cos(wind_direction));

	// Animated 3D position for fog sampling
	vec3 fog_pos = WORLD_POSITION;

	// Horizontal wind drift
	fog_pos.xz -= TIME * wind_speed * wind_dir;

	// Add wavy turbulence for organic movement
	fog_pos.xz += sin(WORLD_POSITION.z * wave_frequency) * wave_amplitude;
	fog_pos.xz += cos(WORLD_POSITION.x * wave_frequency * 0.7) * wave_amplitude * 0.5;

	// Vertical drift (snow falling/swirling)
	fog_pos.y -= TIME * vertical_drift;

	// Primary triangle noise for main fog bands
	float noise = triangle_noise_3d(fog_pos * noise_scale);

	// Secondary detail layer at higher frequency
	float detail = triangle_noise_3d(fog_pos * noise_scale * 3.0) * 0.3;

	// Combine layers (70% primary, 30% detail)
	noise = noise * 0.7 + detail;

	// Apply density with soft maximum cap
	// The max_opacity prevents "opaque curtain" effect
	DENSITY = noise * density;
	DENSITY = min(DENSITY, max_opacity);

	// Only render inside the fog volume
	DENSITY *= step(0.0, -SDF);

	// Color output
	ALBEDO = fog_albedo;
	EMISSION = emission;
}
