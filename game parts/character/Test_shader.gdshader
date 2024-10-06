shader_type canvas_item;

uniform vec4 new_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // The new color to apply
uniform float threshold = 0.1; // Tolerance for detecting black

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV); // Sample the texture color
	
	// Calculate the brightness (shading) of the pixel
	float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

	// Check if the pixel color is close to black (within the threshold)
	if (length(tex_color.rgb) < threshold) {
		// Apply the new color while keeping the original brightness
		vec3 final_color = new_color.rgb;
		COLOR = vec4(final_color, tex_color.a); // Preserve the original alpha
	} else {
		// If the color isn't close to black, keep the original color
		COLOR = tex_color;
	}
}
