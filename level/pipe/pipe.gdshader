shader_type canvas_item;

uniform float fill;

void fragment() {
	float position = UV.x;
	vec3 liquid_sample = mix(vec3(0.4), vec3(0.0, 0.3, 1.0), float(position < fill));
	COLOR = vec4(mix(liquid_sample, COLOR.rgb, COLOR.a), 1.0);
}