shader_type spatial;

// We first load the two displacement images
uniform sampler2D blender_ocean_texture_1 : source_color, repeat_enable, filter_linear_mipmap;
uniform sampler2D blender_ocean_texture_2 : source_color, repeat_enable, filter_linear_mipmap;

uniform float displacement_factor;  // The height of the displacement
uniform float wave_speed; // Speed of the displacement

uniform float normal_eps:hint_range(0.0, 2.0, 0.01) = 0.04; /*This parameter is used to
 calcualte the normals, you can play around with the value to see different results.*/
uniform vec3 color_of_sea:source_color = vec3(0.01, 0.03, 0.05); // The color of the sea

uniform float UV_scale_x; // The scale of the UV for the textures in x then y
uniform float UV_scale_y;
uniform vec2 UV_shift_1; // direction each texture will be panned
uniform vec2 UV_shift_2;

varying vec2 world_position_A; // The world position of the Vertex
varying vec2 world_position_B;
varying vec3 wave_height; // The final Vertex position in xyz coordinates
varying vec3 vertex_normal_world; // The normal at the current Vertex

vec3 get_wave_displacement(vec2 uv_to_sample_A, vec2 uv_to_sample_B){

    /* This function takes two UV's and returns the sampled and mixed rgb value at those points*/

    vec3 displacement_texture_A = texture(blender_ocean_texture_1, uv_to_sample_A).rgb
        *displacement_factor;
    vec3 displacement_texture_B = texture(blender_ocean_texture_2, uv_to_sample_B).rgb
        *displacement_factor;
	
    /* Depending on how much we want each texture to influence the final result we can change 
    the mix factor*/
    
    return mix(displacement_texture_A,displacement_texture_B,0.3);
}

void vertex() {

    // We first calculate the world position of the UV's to sample in each texture.

    world_position_A = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz*vec2(UV_scale_x,UV_scale_y) 
        + (UV_shift_1)  * TIME*wave_speed;
    world_position_B = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz*vec2(UV_scale_x,UV_scale_y) 
        + (UV_shift_2) * TIME*wave_speed;
        
    // With the world UV's we can retrieve the final rgb displacement.
    wave_height = get_wave_displacement(world_position_A,world_position_B);
	
    // We then apply the displacement to the Vertex position
    VERTEX += wave_height;

    // This is the way to calculate the normals as described in the godot spatial shader tutorial

    float h_center = wave_height.y;
    float h_x = get_wave_displacement(world_position_A+ vec2(normal_eps,0.0),world_position_B 
        + vec2(normal_eps,0.0)).g;
    float h_z = get_wave_displacement(world_position_A + vec2(0.0, normal_eps),world_position_B 
        + vec2(0.0, normal_eps)).g;
    vertex_normal_world = normalize(vec3(h_center - h_x, normal_eps, h_center - h_z));
	
}

void fragment() {
    // We apply the normal to the Normals in the fragment shader
    NORMAL = (VIEW_MATRIX * vec4(vertex_normal_world, 0.0)).xyz;
    
    /* Finally we set the fresnel, mettalic and roughtness of the water in the same way
    as in the godot spatial shader tutorial */
    float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
    
    METALLIC = 0.1;
    ROUGHNESS = 0.01 * (1.0 - fresnel);
    ALBEDO = color_of_sea;
}