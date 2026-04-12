shader_type spatial;
render_mode cull_front, unshaded;
#include "func.gdshaderinc"

uniform mat4 cutplane;
uniform vec3 color: source_color;
uniform sampler2D s_noise;
varying vec3 wvtx;

void vertex() {
	wvtx = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float dist = cutDistance(-cutplane[2].xyz, cutplane[3].xyz, wvtx, s_noise);
	if (dist < 0.0) discard;
	ALBEDO = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
