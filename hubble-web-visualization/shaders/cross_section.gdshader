shader_type spatial;
render_mode cull_disabled;
#include "func.gdshaderinc"

uniform mat4 cutplane;
uniform sampler2D _albedo: source_color;
uniform vec3 border_color: source_color;
uniform sampler2D s_noise;
varying vec3 wvtx;

void vertex(){
	wvtx = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
}

void fragment(){
	float dist = cutDistance(-cutplane[2].xyz,cutplane[3].xyz,wvtx,s_noise);
	
	if (dist < 0.0) discard;
	float border_dist = smoothstep(0.0, 0.05, dist);
	vec3 alb_color = texture(_albedo,UV).rgb;
	ALBEDO = (mix(border_color, texture(_albedo, UV).rgb, border_dist)).rgb;
	EMISSION = (mix(border_color * 7.0, vec3(0.0), border_dist)).rgb;
}
