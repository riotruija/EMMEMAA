shader_type canvas_item;

uniform float strength : hint_range(0.0, 0.02) = 0.0;
uniform vec2 direction = vec2(1.0, 0.0);
uniform sampler2D screenTex : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 offset = direction * strength;

    vec4 col;

    // Offset color channels differently
    col.r = texture(screenTex, SCREEN_UV + offset).r;
    col.g = texture(screenTex, SCREEN_UV).g;
    col.b = texture(screenTex, SCREEN_UV - offset).b;
    col.a = 1.0;

    COLOR = col;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
