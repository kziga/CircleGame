shader_type canvas_item;

uniform float wave_speed : hint_range(0.0, 20.0) = 3.0; // Speed of the wave
uniform float wave_freq : hint_range(0.0, 50.0) = 10.0; // Frequency of the wave
uniform float wave_width : hint_range(0.0, 2.0) = 0.01; // Width of the wave

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = SCREEN_UV;
    // Calculate the distortion based on time and vertical position
    vec2 wave_uv = vec2(UV.x + sin(UV.y * wave_freq + TIME * wave_speed) * wave_width, UV.y);
    
    // Apply the distortion to the texture
    vec4 text = texture(TEXTURE, wave_uv);
    COLOR = text;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
