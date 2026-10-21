//precision lowp float;
//precision lowp int;

#define BaseLightIntensity 0.0185
#define e 2.71828

#define MaxLights 48

#define GreyScaleWeights vec3(0.2125, 0.7154, 0.0721)
#define YUVWeights vec3(0.299, 0.587, 0.114)

varying vec2 v_vTexcoord;
varying vec2 v_vPosition;


uniform float Alpha;

//Lighting
uniform bvec2 Lighting_Status;		//x=main, y = lights
uniform bvec2 Lighting_RoomStatus;  //x=main, y = trans
uniform vec4 Lighting_RoomBoundary0;
uniform vec4 Lighting_RoomBoundary1;
uniform vec4 Lighting_RoomRGB0;
uniform vec4 Lighting_RoomRGB1;

uniform vec3 Lighting_LightArray_Pos0[MaxLights];	//x, y, radius
uniform vec3 Lighting_LightArray_Pos1[MaxLights];
uniform vec3 Lighting_LightArray_RGB0[MaxLights];
uniform vec3 Lighting_LightArray_RGB1[MaxLights];
uniform vec3 Lighting_Link_Pos;
uniform vec3 Lighting_Link_RGB;


//Palette 
uniform bool PaletteStatus;
uniform sampler2D u_palTexture;
uniform vec4 u_Uvs;
uniform float u_paletteId;
uniform vec2 u_pixelSize;


//Color 
uniform bool Color_Status;
uniform vec4 Color_Tint;


vec4 DoLighting_Room0(vec4 Pixel){ //main room, always visible
		
	if(!Lighting_Status.x) return Pixel;
	
	if(!Lighting_RoomStatus.x) return Pixel;
	
	bool PixelInRoom = (v_vPosition.x >= Lighting_RoomBoundary0.x && v_vPosition.x <= Lighting_RoomBoundary0.z + 1.0 && v_vPosition.y >= Lighting_RoomBoundary0.y && v_vPosition.y <= Lighting_RoomBoundary0.w + 1.0);
	if(!PixelInRoom) return Pixel;
	
	vec4 Light = Lighting_RoomRGB0 * Pixel;
	
	if(!Lighting_Status.y) return Light;
	
	float Distance;
	float Intensity;	
	
    for(int i = 0; i < MaxLights; i++){
		Distance = length(Lighting_LightArray_Pos0[i].xy - v_vPosition) / Lighting_LightArray_Pos0[i].z;
		Intensity = max(2.2 / (1.0 + pow(e, (Distance / 9.0) - 2.0)), BaseLightIntensity);
		Light.rgb += (Intensity * Lighting_LightArray_RGB0[i]);		
    }
	
	//Link's light
	Distance = length(Lighting_Link_Pos.xy - v_vPosition) / Lighting_Link_Pos.z;
	Intensity = max(2.2 / (1.0 + pow(e, (Distance / 9.0) - 2.0)), BaseLightIntensity);
	Light.rgb += (Intensity * Lighting_Link_RGB);		
		
	return Light * Pixel;
	
}

vec4 DoLighting_Room1(vec4 Pixel){ //transitioning room
		
	if(!Lighting_Status.x) return Pixel;
	
	if(!Lighting_RoomStatus.y) return Pixel;
	
	bool PixelInRoom = (v_vPosition.x >= Lighting_RoomBoundary1.x && v_vPosition.x <= Lighting_RoomBoundary1.z + 1.0 && v_vPosition.y >= Lighting_RoomBoundary1.y && v_vPosition.y <= Lighting_RoomBoundary1.w + 1.0);
	if(!PixelInRoom) return Pixel;
	
	vec4 Light = Lighting_RoomRGB1 * Pixel;
	
	if(!Lighting_Status.y) return Light;
	
	float Distance;
	float Intensity;	
	
    for(int i = 0; i < MaxLights; i++){
		Distance = length(Lighting_LightArray_Pos1[i].xy - v_vPosition) / Lighting_LightArray_Pos1[i].z;
		Intensity = max(2.2 / (1.0 + pow(e, (Distance / 9.0) - 2.0)), BaseLightIntensity);
		Light.rgb += (Intensity * Lighting_LightArray_RGB1[i]);		
    }

	//Link's light
	Distance = length(Lighting_Link_Pos.xy - v_vPosition) / Lighting_Link_Pos.z;
	Intensity = max(2.2 / (1.0 + pow(e, (Distance / 9.0) - 2.0)), BaseLightIntensity);
	Light.rgb += (Intensity * Lighting_Link_RGB);	
	
	return Light * Pixel;
	
}


float YUVval(vec4 _rgb){
    return dot(YUVWeights, _rgb.rgb);
}

vec4 DoColor(vec4 Pixel){

	if(!Color_Status) return Pixel;
	
	//special negative values for different effects
	if(Color_Tint.r == -1.0){ //bright
		Pixel.rgb *= 2.25;
		return Pixel;
	}else if(Color_Tint.r == -2.0){ //greyscale
		float Lum = dot(Pixel.rgb, GreyScaleWeights);
		Pixel.rgb = vec3(Lum, Lum, Lum);
		return Pixel;
	}else if(Color_Tint.r == -3.0) //invert
		return vec4(vec3(1.0) - Pixel.rgb, Pixel.a);
	
    float tintval = YUVval(Color_Tint);
    float texval = YUVval(Pixel);
    
    vec4 outcol;
    if (texval < tintval){
        outcol = mix(vec4(0.0, 0.0, 0.0, 1.0), Color_Tint, texval / tintval);
    }else if (texval < 1.0){
        outcol = mix(Color_Tint, vec4(1.0, 1.0, 1.0, 1.0), (texval - tintval) / (1.0 - tintval));
    }else{
        outcol = vec4(1.0, 1.0, 1.0, 1.0);   
    }

    outcol.a = Pixel.a;   
    
	float Color_Intensity = 1.0;
	
    return mix(Pixel, outcol, Color_Intensity);

}



vec4 DoPalette(vec4 Pixel){
    
	if(!PaletteStatus) return Pixel;
	
    vec2 testPos;
	vec2 corner = u_Uvs.xy;
    for(float i = corner.y; i < u_Uvs.w; i+=u_pixelSize.y ){
		testPos = vec2(corner.x,i);
		if(distance(texture2D( u_palTexture, testPos), Pixel) < 0.004){
			testPos = vec2(corner.x + u_pixelSize.x * floor(u_paletteId + 1.0), i);
			return mix(texture2D(u_palTexture, vec2(testPos.x - u_pixelSize.x, testPos.y)), texture2D(u_palTexture, testPos), fract(u_paletteId));
		}
    }
	
    return Pixel;
}


void main(){
	
	vec4 TexColor = texture2D( gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(DoLighting_Room0(DoLighting_Room1(DoColor(DoPalette(TexColor)))).rgb, TexColor.a * Alpha);
	
}

