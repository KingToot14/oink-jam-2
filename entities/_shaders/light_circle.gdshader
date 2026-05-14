shader_type canvas_item;
render_mode blend_add;

#include "res://resources/shaders/generic.gdshaderinc"

// --- Uniforms --- //
uniform float texture_size = 64.0;
uniform float radius = 8.0;

uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(texture_size));
	float dist = distance(uv, vec2(0.5)) * texture_size;
	
	COLOR.a = step(abs(dist), radius) * alpha;
}