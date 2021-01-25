shader_type spatial;
render_mode unshaded;
varying vec3 norm;

uniform bool use_outline = true;

void vertex() {

    norm.rgb = NORMAL.rgb;
}
void fragment(){
    if(use_outline){
        vec3 r = mix(vec3(2.,0.,2.), norm, 0.2);
        ALBEDO = r;
    }else{
        ALBEDO = vec3(1);    
    }
}

