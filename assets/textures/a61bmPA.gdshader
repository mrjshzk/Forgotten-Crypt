shader_type spatial;
render_mode specular_schlick_ggx, ambient_light_disabled;

uniform vec4 Color : source_color;
uniform float Shine = 1;
uniform float Roughness = 0.2;



void vertex() {
// Output:0

}

void fragment() {
// ColorUniform:6
	vec3 n_out6p0 = Color.rgb;
	float n_out6p1 = Color.a;

// ScalarUniform:3
	float n_out3p0 = Shine;

// ScalarUniform:4
	float n_out4p0 = Roughness;

// Output:0
	ALBEDO = n_out6p0;
	ALPHA = n_out6p1;
	METALLIC = n_out3p0;
	ROUGHNESS = n_out4p0;

}

void light() {
// Output:0

}