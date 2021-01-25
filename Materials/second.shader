shader_type spatial;
render_mode cull_disabled;
uniform sampler2D tex : hint_albedo;
uniform float outline_weight = 1.0;
uniform vec4 main_color : hint_color = vec4(0.5,0.5,0.5,1);
uniform bool use_vertex_color = true;
varying vec3 col;
uniform bool use_outline = true;
uniform bool use_tex = false;
uniform bool force_rgb = true;
void vertex() {
    if (!force_rgb && !OUTPUT_IS_SRGB) {
		COLOR.rgb = mix( pow((COLOR.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)), COLOR.rgb* (1.0 / 12.92), lessThan(COLOR.rgb,vec3(0.04045)) );
	}
    col = COLOR.rgb;

}
void fragment(){
    vec3 res;
    if(use_outline){

          float w = 1./1960.;
    	  float h = 1./1080.;
        
          vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
        	vec4 n0 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, -h));
        	vec4 n1 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -h));
        	vec4 n2 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, -h));
        	vec4 n3 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, 0.0));
        //	vec4 n4 = texture(SCREEN_TEXTURE, SCREEN_UV);
        	vec4 n5 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, 0.0));
        	vec4 n6 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2( -w, h));
        	vec4 n7 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, h));
        	vec4 n8 = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(  w, h));
    
    	vec4 sobel_edge_h = (n2 + (2.*n5) + n8 - (n0 + (2.*n3) + n6)) * outline_weight;
        vec4 sobel_edge_v = (n0 + (2.*n1) + n2 - (n6 + (2.*n7) + n8)) * outline_weight;
    	vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
        
        float alpha = (sobel.r  + sobel.g + sobel.b) / 3.0;
    
    //    else if(alpha >= 0.8)
    //        alpha = 0.8;
        if(use_tex){
                
                res = mix(texture(tex, UV).rgb, vec3(0.), alpha);
            }
        else if(use_vertex_color){
                res = mix(col, vec3(0.), alpha);
//                res = col;
            }
        else{
           res = mix(main_color.rgb, vec3(0.), alpha);
        }
    }
    else{
        if(use_tex){
                res = texture(tex, UV).rgb;
            }
        else if(use_vertex_color){
                res = col.rgb;
            }
        else
           res = main_color.rgb;
    }
    
    ALBEDO = res;
    if(use_tex)
       ALPHA = texture(tex, UV).a;
}