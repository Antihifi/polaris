shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

// Rope appearance
uniform sampler2D rope_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform float rope_radius : hint_range(0.01, 0.1) = 0.03;
uniform float texture_scale : hint_range(0.1, 10.0) = 2.0;

// Catenary control - set per-instance from GDScript
instance uniform vec3 start_pos;
instance uniform vec3 end_pos;
instance uniform float tension : hint_range(0.0, 2.0) = 0.5;

// Animation
uniform float wind_strength : hint_range(0.0, 0.1) = 0.02;
uniform float wind_speed : hint_range(0.1, 5.0) = 1.5;

// Strain visualization
uniform vec3 strain_color : source_color = vec3(0.6, 0.3, 0.2);
uniform float strain_threshold : hint_range(0.8, 1.5) = 1.0;


varying float v_along_rope;  // 0 at start, 1 at end
varying vec3 v_world_pos;


void vertex() {
	// The mesh is a flat quad along X axis (length) with Y for billboard offset
	// VERTEX.x ranges from -0.5 to 0.5 (rope length)
	// VERTEX.y ranges from -0.5 to 0.5 (rope thickness/billboard)

	float t = VERTEX.x + 0.5;  // Normalize to 0-1 along rope
	v_along_rope = t;

	// Interpolate position along rope
	vec3 rope_dir = end_pos - start_pos;
	float rope_length = length(rope_dir);
	vec3 rope_dir_norm = rope_dir / max(rope_length, 0.001);

	// Calculate base position along straight line
	vec3 pos = start_pos + rope_dir * t;

	// Apply catenary sag (parabolic approximation for performance)
	// Sag is maximum at center (t=0.5), zero at ends
	// Sag amount inversely proportional to tension
	float sag_factor = 4.0 * t * (1.0 - t);  // Parabola: 0 at ends, 1 at center
	float max_sag = rope_length * 0.3 * (1.0 - clamp(tension, 0.0, 1.0));

	// Add slight asymmetry for more natural look
	float asymmetry = sin(t * 3.14159) * 0.1;
	float sag = max_sag * sag_factor * (1.0 + asymmetry);

	pos.y -= sag;

	// Wind animation - sine wave displacement
	float wind_phase = TIME * wind_speed + t * 6.28318;
	float wind_offset = sin(wind_phase) * wind_strength * sag_factor * rope_length;

	// Apply wind perpendicular to rope direction (in XZ plane)
	vec3 wind_dir = normalize(vec3(-rope_dir_norm.z, 0.0, rope_dir_norm.x));
	pos += wind_dir * wind_offset;

	// Billboard expansion for rope thickness
	// Get camera direction and create perpendicular offset
	vec3 to_camera = normalize(CAMERA_POSITION_WORLD - pos);
	vec3 right = normalize(cross(rope_dir_norm, to_camera));

	// VERTEX.y controls offset from rope centerline
	float thickness_offset = VERTEX.y * rope_radius * 2.0;
	pos += right * thickness_offset;

	// Strain vibration when over-tensioned
	if (tension > strain_threshold) {
		float strain_amount = (tension - strain_threshold) / (2.0 - strain_threshold);
		float vibration = sin(TIME * 30.0 + t * 20.0) * 0.01 * strain_amount;
		pos += right * vibration;
	}

	v_world_pos = pos;

	// Transform to clip space
	VERTEX = (inverse(MODEL_MATRIX) * vec4(pos, 1.0)).xyz;
}


void fragment() {
	// Sample rope texture with UV based on position along rope
	vec2 rope_uv = vec2(v_along_rope * texture_scale, UV.y);
	vec4 tex_color = texture(rope_texture, rope_uv);

	ALBEDO = tex_color.rgb;

	// Add strain tint when rope is very taut
	if (tension > strain_threshold) {
		float strain_blend = clamp((tension - strain_threshold) * 2.0, 0.0, 0.5);
		ALBEDO = mix(ALBEDO, strain_color, strain_blend);
	}

	// Roughness for hemp rope look
	ROUGHNESS = 0.85;
	METALLIC = 0.0;

	// Simple normal for depth - fake tubular look
	float edge_factor = abs(UV.y - 0.5) * 2.0;  // 0 at center, 1 at edges
	NORMAL = normalize(vec3(0.0, 1.0 - edge_factor * 0.5, edge_factor * 0.3));
}
