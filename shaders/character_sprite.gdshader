shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.);
uniform float flash_percentage: hint_range(0.,1.) = 0;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	COLOR.rgb = mix(original_color.rgb,flash_color.rgb,flash_percentage);
	COLOR.a = original_color.a;
	
	
	//COLOR.a = original_color.a;
}
