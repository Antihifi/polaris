shader_type canvas_item;

uniform vec4 icon_color : source_color = vec4(0.773, 0.675, 0.514, 1.0);
uniform vec4 bg_color : source_color = vec4(0.188, 0.204, 0.251, 1.0);
uniform vec4 edge_color : source_color = vec4(0.3, 0.25, 0.15, 1.0);
uniform float sensitivity : hint_range(0.0, 1.0) = 0.4;
uniform sampler2D noise_texture : repeat_enable;
const float edge_width = 0.15;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Transparent pixels -> background color
	if (tex.a < 0.01) {
		COLOR = bg_color;
	} else {
		// Recolor opaque icon pixels to gold
		vec3 recolored = icon_color.rgb;

		// Snap UV to pixel grid for pixel-perfect noise sampling
		float size_x = float(textureSize(TEXTURE, 0).x);
		float size_y = float(textureSize(TEXTURE, 0).y);
		vec2 UVr = vec2(floor(UV.x * size_x) / size_x, floor(UV.y * size_y) / size_y);

		// Sample noise
		float noise_value = texture(noise_texture, UVr).r;

		// Smoothstep damage threshold
		float edge_lower = sensitivity - edge_width;
		float edge_upper = sensitivity + edge_width;
		float factor = smoothstep(edge_lower, edge_upper, noise_value);

		// Interpolate: damaged areas blend from edge_color -> original, clean areas stay gold
		vec4 damaged = mix(edge_color, vec4(recolored, 1.0), factor);
		vec4 final_color = mix(damaged, vec4(recolored, 1.0), factor);

		COLOR = vec4(final_color.rgb, tex.a);
	}
}
