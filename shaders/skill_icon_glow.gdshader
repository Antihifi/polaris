shader_type spatial;
render_mode unshaded, cull_disabled, blend_add;

// Overlay shader: adds a pulsing glow on top of the Sprite3D's base texture.
// Apply as Material Overlay (NOT Material Override) so the icon renders normally.

uniform vec4 glow_color : source_color = vec4(0.7, 0.85, 1.0, 1.0);
uniform float glow_strength : hint_range(0.0, 3.0) = 1.0;
uniform float pulse_speed : hint_range(0.0, 5.0) = 1.5;
uniform float pulse_min : hint_range(0.0, 1.0) = 0.7;

void fragment() {
	float pulse = mix(pulse_min, 1.0, sin(TIME * pulse_speed) * 0.5 + 0.5);

	ALBEDO = glow_color.rgb * glow_strength * pulse;
	ALPHA = glow_color.a * pulse * 0.4;
}
