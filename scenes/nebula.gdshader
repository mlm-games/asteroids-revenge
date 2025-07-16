shader_type canvas_item;

uniform vec4 color_deep_space : source_color = vec4(0.01, 0.02, 0.08, 1.0);
uniform vec4 color_nebula_mid : source_color = vec4(0.3, 0.1, 0.4, 1.0);
uniform vec4 color_nebula_bright : source_color = vec4(0.8, 0.2, 0.5, 1.0);

uniform float scale = 2.0;
uniform int octaves = 5; // More octaves = more detail, slightly slower
uniform vec2 scroll_speed = vec2(0.02, 0.01);

// Helper function to generate a pseudo-random value from a 2D vector
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D Noise function based on the random function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners of a rectangle
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smoothly interpolate between the corners
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.y * u.x;
}

// Fractional Brownian Motion - layering noise for a cloudy effect
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;

    for (int i = 0; i < octaves; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    // Adjust UV with scale and add scrolling motion with TIME
    vec2 uv = UV * scale;
    uv += TIME * scroll_speed;

    // Generate the base noise value
    float noise_val = fbm(uv);

    // Mix colors based on the noise value to create the nebula effect
    // Start with the deep space color
    vec3 final_color = color_deep_space.rgb;

    // Add the first layer of nebula color, controlling its threshold with smoothstep
    final_color = mix(final_color, color_nebula_mid.rgb, smoothstep(0.3, 0.6, noise_val));

    // Add the bright core highlights
    final_color = mix(final_color, color_nebula_bright.rgb, smoothstep(0.5, 0.7, noise_val));

    COLOR = vec4(final_color, 0.03);
}