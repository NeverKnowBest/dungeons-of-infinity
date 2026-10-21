varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

uniform float mosaic_size;
uniform float mosaic_brightness;

void main()
{ 

    vec2 size = vec2(1.0/mosaic_size, 1.7777777/mosaic_size);
    vec2 uv;
	uv = v_vTexcoord - mod(v_vTexcoord,size);

	float _r = mosaic_brightness;//(0.25 * sin(mosaic_size)) + 0.75; //for sickness effect
	float _g = mosaic_brightness;//(0.25 * sin(mosaic_size / 2.0)) + 0.75;
	float _b = mosaic_brightness;//(0.25 * sin(mosaic_size) / 3.0) + 0.75;
	
    gl_FragColor = texture2D( gm_BaseTexture, uv );
}
