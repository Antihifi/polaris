shader_type spatial;
render_mode unshaded, cull_disabled;

// Material Override shader for Sprite3D skill icons.
// Renders the icon texture with a pulsing glow tint.
// Apply as Material Override. Set icon_texture to the sprite's texture (e.g. navigator.png).

uniform sampler2D icon_texture : source_color, filter_linear;
uniform vec4 glow_color : source_color = vec4(0.7, 0.85, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 3.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 5.0) = 1.5;
uniform float pulse_min : hint_range(0.0, 1.0) = 0.7;

void fragment() {
	vec4 tex = texture(icon_texture, UV);
	float pulse = mix(pulse_min, 1.0, sin(TIME * pulse_speed) * 0.5 + 0.5);

	// Mix icon color with glow tint
	vec3 tinted = mix(tex.rgb, glow_color.rgb, glow_strength * 0.3 * pulse);

	ALBEDO = tinted;
	ALPHA = tex.a * pulse;
}
