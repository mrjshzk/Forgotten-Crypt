// This Version is working in GLES2, but it will need some further improvements
// You can not change the resolution.

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform int color_depth : hint_range(1, 8) = 5;
uniform bool dithering = true;

const mat4 pattern = mat4(
    vec4(-4, +0, -3, +1),
    vec4(+2, -2, +3, -1),
    vec4(-3, +1, -4, +0),
    vec4(+3, -1, +2, -2)
);


int dithering_pattern(ivec2 fragcoord) {
    int x = fragcoord.x % 4;
    int y = fragcoord.y % 4;

    vec4 pattern_vec4;

    if (y == 0) pattern_vec4 = pattern[0];
    else if (y == 1) pattern_vec4 = pattern[1];
    else if (y == 2) pattern_vec4 = pattern[2];
    else if (y == 3) pattern_vec4 = pattern[3];

    float pattern_int;

    if (x == 0) pattern_int = pattern_vec4.x;
    else if (x == 1) pattern_int = pattern_vec4.y;
    else if (x == 2) pattern_int = pattern_vec4.z;
    else if (x == 3) pattern_int = pattern_vec4.w;

    return int(pattern_int);
}

void fragment() {
    vec2 pixel_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec3 color = texture(SCREEN_TEXTURE, round(SCREEN_UV * pixel_size) / pixel_size).rgb;
    
    // Convert from [0.0, 1.0] range to [0, 255] range
    ivec3 c = ivec3(round(color * 255.0));
    
    if (dithering) {
        c += ivec3(dithering_pattern(ivec2(FRAGCOORD.xy)));
    }
    
    // Truncate from 8 bits to color_depth bits
    c = c / int(pow(2.0, float(8 - color_depth)));
    
    // Convert back
    c = c * int(pow(2.0, float(8 - color_depth)));
    
    COLOR.rgb = vec3(c) / 255.0;
    
}