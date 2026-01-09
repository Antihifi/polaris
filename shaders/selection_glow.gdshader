shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque, blend_add;

group_uniforms colors;
uniform vec4 glow_color : source_color = vec4(1.0, 0.6, 0.2, 1.0);
uniform vec4 accent_color : source_color = vec4(1.0, 0.85, 0.4, 1.0);
uniform float emission_strength : hint_range(0.0, 3.0) = 1.5;

group_uniforms animation;
uniform float rotation_speed : hint_range(-3.0, 3.0) = 0.5;
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_min : hint_range(0.0, 1.0) = 0.6;
uniform float pulse_max : hint_range(0.5, 2.0) = 1.0;

group_uniforms shape;
uniform int num_slashes : hint_range(1, 12) = 4;
uniform float slash_sharpness : hint_range(1.0, 20.0) = 8.0;
uniform float slash_width : hint_range(0.1, 2.0) = 0.6;
uniform float inner_radius : hint_range(0.0, 0.9) = 0.3;
uniform float outer_radius : hint_range(0.1, 1.0) = 0.95;
uniform float edge_softness : hint_range(0.01, 0.3) = 0.1;

group_uniforms noise;
uniform float noise_scale : hint_range(1.0, 20.0) = 8.0;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.3;
uniform float noise_speed : hint_range(0.0, 2.0) = 0.5;

varying vec3 local_pos;

// Simple noise function
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec2 polar_coordinates(vec2 cartesian) {
	float radius = length(cartesian);
	float angle = atan(cartesian.y, cartesian.x);
	return vec2(radius, angle);
}

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	// Convert to polar coordinates from mesh center (XZ plane for flat cylinder)
	vec2 centered = local_pos.xz;
	vec2 polar = polar_coordinates(centered);
	float radius = polar.x;
	float angle = polar.y;

	// Animated angle for rotation
	float animated_angle = angle + TIME * rotation_speed;

	// Create slash pattern using sine waves
	float slash_pattern = sin(animated_angle * float(num_slashes)) * 0.5 + 0.5;

	// Add noise for organic look
	vec2 noise_uv = vec2(angle * noise_scale, radius * noise_scale + TIME * noise_speed);
	float n = noise(noise_uv) * noise_strength;
	slash_pattern = clamp(slash_pattern + n - noise_strength * 0.5, 0.0, 1.0);

	// Sharpen the slashes
	slash_pattern = pow(slash_pattern, slash_sharpness * (1.0 - slash_width));

	// Ring mask - fade at inner and outer edges
	float inner_mask = smoothstep(inner_radius - edge_softness, inner_radius + edge_softness, radius);
	float outer_mask = 1.0 - smoothstep(outer_radius - edge_softness, outer_radius, radius);
	float ring_mask = inner_mask * outer_mask;

	// Pulsing animation
	float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
	pulse = mix(pulse_min, pulse_max, pulse);

	// Secondary pulse offset for slashes
	float slash_pulse = sin(TIME * pulse_speed * 1.3 + 1.0) * 0.5 + 0.5;

	// Color mixing - slashes get accent color
	vec3 base = glow_color.rgb;
	vec3 highlight = accent_color.rgb;
	vec3 final_color = mix(base, highlight, slash_pattern * slash_pulse);

	// Apply pulse to intensity
	float intensity = emission_strength * pulse;

	// Final alpha combines ring mask and slash pattern
	float alpha = ring_mask * (0.4 + slash_pattern * 0.6) * pulse;

	// Output
	ALBEDO = final_color * intensity;
	ALPHA = alpha * glow_color.a;
	EMISSION = final_color * intensity;
}
