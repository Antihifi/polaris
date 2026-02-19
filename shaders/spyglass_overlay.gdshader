shader_type canvas_item;

// 1840s Spyglass Visual Effect - Optimized version
// Uses baked overlay texture for dirt/cracks instead of procedural generation

// ===== CIRCLE & VIGNETTE =====
uniform float circle_radius : hint_range(0.0, 1.0) = 0.45;
uniform float vignette_start : hint_range(0.0, 1.0) = 0.35;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.7;

// ===== ASPECT RATIO CORRECTION =====
uniform vec2 screen_size = vec2(1920.0, 1080.0);

// ===== DISTORTION =====
uniform float barrel_distortion : hint_range(0.0, 0.3) = 0.08;
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.004;

// ===== BAKED OVERLAY (dirt + cracks) =====
uniform sampler2D overlay_texture : hint_default_white;
uniform float overlay_intensity : hint_range(0.0, 1.0) = 0.15;

// ===== SCREEN TEXTURE =====
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


// ===== DISTORTION FUNCTIONS =====
vec2 barrel_distort(vec2 uv, float amount) {
    vec2 center = uv - 0.5;
    float dist = length(center);
    float factor = 1.0 + amount * dist * dist;
    return center * factor + 0.5;
}


// ===== MAIN FRAGMENT =====
void fragment() {
    // Aspect ratio correction for perfect circle
    float aspect = screen_size.x / screen_size.y;
    vec2 center_offset = UV - 0.5;
    center_offset.x *= aspect;
    float dist = length(center_offset);

    float effective_radius = circle_radius * min(aspect, 1.0);
    float effective_vignette_start = vignette_start * min(aspect, 1.0);

    // Outside circle = black
    if (dist > effective_radius) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // Barrel distortion
        vec2 distorted_uv = barrel_distort(SCREEN_UV, barrel_distortion);

        // Chromatic aberration (3 texture samples)
        vec2 dir = normalize(distorted_uv - 0.5);
        float ca_amount = chromatic_aberration * dist * 2.0;
        vec3 screen_color = vec3(
            texture(SCREEN_TEXTURE, distorted_uv + dir * ca_amount).r,
            texture(SCREEN_TEXTURE, distorted_uv).g,
            texture(SCREEN_TEXTURE, distorted_uv - dir * ca_amount).b
        );

        // Baked overlay (dirt + cracks) - single texture sample
        float overlay = texture(overlay_texture, UV).r;
        screen_color *= mix(1.0, overlay, overlay_intensity);

        // Vignette
        float vignette = smoothstep(effective_vignette_start, effective_radius, dist);
        screen_color *= mix(1.0, 1.0 - vignette_strength, vignette);

        // Subtle sepia tint
        vec3 sepia = vec3(
            dot(screen_color, vec3(0.393, 0.769, 0.189)),
            dot(screen_color, vec3(0.349, 0.686, 0.168)),
            dot(screen_color, vec3(0.272, 0.534, 0.131))
        );
        screen_color = mix(screen_color, sepia, 0.1);

        COLOR = vec4(screen_color, 1.0);
    }
}
