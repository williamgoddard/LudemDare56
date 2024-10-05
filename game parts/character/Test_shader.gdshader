shader_type canvas_item;

uniform vec4 old_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // The color to replace
uniform vec4 new_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // The new color to apply
uniform float threshold = 0.1; // Tolerance for matching the old color

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV); // Sample the texture color
	
	// Calculate the brightness (shading) of the pixel
	float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

	// Check if the pixel color matches the old color within the threshold
	if (distance(tex_color.rgb, old_color.rgb) < threshold) {
		// Apply the new color while keeping the original brightness
		vec3 final_color = new_color.rgb * brightness;
		COLOR = vec4(final_color, tex_color.a); // Preserve the original alpha
	} else {
		// If the color doesn't match, keep the original color
		COLOR = tex_color;
	}
}
