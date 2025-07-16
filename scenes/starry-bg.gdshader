shader_type canvas_item;

uniform vec4 star_color : source_color = vec4(1.0, 1.0, 0.85, 1.0);
uniform sampler2D star_texture;
uniform float star_size : hint_range(0.1, 5.0) = 1.0;
uniform float star_alpha : hint_range(0.0, 1.0) = 1.0;

uniform vec2 speed_layer_1 = vec2(15.0, 0.0);
uniform float density_layer_1: hint_range(0.0, 1.0) = 0.007;

uniform vec2 speed_layer_2 = vec2(30.0, 0.0);
uniform float density_layer_2: hint_range(0.0, 1.0) = 0.012;

uniform vec2 speed_layer_3 = vec2(60.0, 0.0);
uniform float density_layer_3: hint_range(0.0, 1.0) = 0.002;

uniform float twinkle_speed : hint_range(0.0, 10.0) = 2.5;

// A simple pseudo-random number generator
float random(vec2 st) {
        return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// This function generates one layer of textured stars
vec4 create_layer(vec2 vertex_pos, vec2 speed, float density) {
        // Calculate the scrolling UV for this layer
        vec2 uv = (vertex_pos + TIME * speed) * 0.03;

        // Get the integer grid coordinate for the star
        vec2 grid_id = floor(uv);
        vec2 grid_uv = fract(uv);

        // Use the random function to decide if a star exists in this grid cell
        float star_exists = step(random(grid_id), density);

        if (star_exists < 0.5) {
                return vec4(0.0);
        }

        // TWINKLE EFFECT
        float twinkle_rand = random(grid_id + vec2(5.3, 2.8));
        float twinkle_value = sin(TIME * twinkle_speed * twinkle_rand) * 0.5 + 0.5;

        // Give stars different base brightness levels
        float base_brightness = random(grid_id + vec2(9.1, 7.4));
        float brightness = mix(0.2, 1.0, base_brightness) * twinkle_value;

        // Calculate random position within the cell
        vec2 star_pos = vec2(
                random(grid_id + vec2(1.3, 3.7)),
                random(grid_id + vec2(8.2, 5.1))
        );

        // Calculate distance from current fragment to star position
        vec2 centered_uv = (grid_uv - star_pos) / star_size + 0.5;

        // Only render if we're within the 0-1 texture bounds
        if (centered_uv.x >= 0.0 && centered_uv.x <= 1.0 &&
            centered_uv.y >= 0.0 && centered_uv.y <= 1.0) {
                // Sample the star texture
                vec4 star = texture(star_texture, centered_uv);

                // Apply color, alpha and brightness
                star.rgb *= star_color.rgb * brightness;
                star.a *= star_color.a * star_alpha * brightness;

                return star;
        }

        return vec4(0.0);
}

// Called for every vertex the material is visible on.
varying vec2 position;
void vertex() {
        position = VERTEX;
}

// Called for every pixel the material is visible on.
void fragment() {
        // Sample the node's original texture (background)
        //vec4 base_color = texture(TEXTURE, UV);

        // Calculate the combined star layers
        vec4 stars_layer_1 = create_layer(position, speed_layer_1, density_layer_1);
        vec4 stars_layer_2 = create_layer(position, speed_layer_2, density_layer_2);
        vec4 stars_layer_3 = create_layer(position, speed_layer_3, density_layer_3);

        // Combine the star layers using alpha blending
        vec4 combined_stars = vec4(0.0);
        combined_stars = mix(combined_stars, stars_layer_1, stars_layer_1.a);
        combined_stars = mix(combined_stars, stars_layer_2, stars_layer_2.a);
        combined_stars = mix(combined_stars, stars_layer_3, stars_layer_3.a);

        // Blend the stars with the background
        vec3 final_rgb = mix(combined_stars.rgb, combined_stars.rgb, combined_stars.a);

        // Add any remaining luminosity
        final_rgb += combined_stars.rgb * combined_stars.a * 0.5;

        // Set the final COLOR
        COLOR = vec4(final_rgb, star_color.a);
}