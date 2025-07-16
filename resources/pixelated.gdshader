shader_type canvas_item;

uniform float pixel_size = 4.0;
uniform float color_levels = 8.0;
uniform bool dither = true;
uniform float chromatic_aberration = 2.0;

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * pixel_size;
    vec2 pixelated_uv = floor(UV / size) * size + size * 0.5;

    // Chromatic aberration
    float r = texture(TEXTURE, pixelated_uv + vec2(TEXTURE_PIXEL_SIZE.x * chromatic_aberration, 0.0)).r;
    float g = texture(TEXTURE, pixelated_uv).g;
    float b = texture(TEXTURE, pixelated_uv - vec2(TEXTURE_PIXEL_SIZE.x * chromatic_aberration, 0.0)).b;
    float a = texture(TEXTURE, pixelated_uv).a;

    vec4 color = vec4(r, g, b, a);

    // Reduce color levels
    color.rgb = floor(color.rgb * color_levels) / color_levels;

    // Simple dithering
    if (dither) {
        float dither_pattern = mod(floor(FRAGCOORD.x) + floor(FRAGCOORD.y), 2.0);
        color.rgb += (dither_pattern - 0.5) * 0.05;
    }

    COLOR = color;
}
