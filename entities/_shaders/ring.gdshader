shader_type canvas_item;
#include "res://resources/shaders/generic.gdshaderinc"

// --- Uniforms --- //
uniform float texture_size: hint_range(1.0, 64.0, 1.0) = 64.0;
uniform float radius: hint_range(1.0, 32.0, 1.0) = 8.0;
uniform float width: hint_range(1.0, 8.0, 1.0) = 2.0;

uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

// --- Functions --- //
void fragment() {
	vec2 uv = pixelize(UV, vec2(texture_size));
	float dist = distance(uv, vec2(0.5)) * texture_size;
	
	COLOR.a = step(abs(dist - radius), width / 2.0) * alpha;
}