
#define MaxLights 500
#define TRUE 1.0
#define FALSE 0.0
#define e 2.71828
#define TOP 0.0
#define BOTTOM 1.0
#define LEFT 2.0
#define RIGHT 3.0
#define Transparent vec4(.0,.0,.0,.0)
#define Silouette vec4(.4, .4, .4, 1.0)
#define GreyScaleWeights vec3(0.2125, 0.7154, 0.0721)
#define YUVWeights vec3(0.299, 0.587, 0.114)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

uniform vec2 resolution;
uniform float pixel_amount;

//Lighting uniforms
uniform float RoomLightingStatus[2];
uniform vec4 RoomLightingBoundary[2];
uniform float LightingStatus;
uniform float LightingStatus_Lights;
uniform int LightCount;
uniform vec2 L[MaxLights];//X,Y
uniform vec3 L_P1[MaxLights];//Parameters 1: R,G,B
uniform vec4 L_P2[MaxLights];//Parameters 2: Strength, InRoom0, InRoom1, Status
uniform vec3 AMB;//R,G,B
uniform float BaseLight;

//Palette uniforms
uniform float PaletteStatus;
uniform sampler2D u_palTexture;
uniform vec4 u_Uvs;
uniform float u_paletteId;
uniform vec2 u_pixelSize;

//Transparency Mask uniforms
uniform float TransparencyMask_Status;
uniform vec4 TransparencyMask_BBox;

//Silouette Mask uniforms
uniform int SilouetteMaskCount;
uniform float SilouetteMask_Status;
uniform vec4 SilouetteMask_BBox[8];

/*

uniform int MaskCount;
uniform float Mask_Status[16];
uniform vec4 Mask_BBox[16];
uniform vec4 Mask_Color[16];

*/


//Color uniforms
uniform float Color_Status;
uniform vec4 Color_Tint;


vec4 DoTransparencyMask(vec4 Pixel){
	
	if(TransparencyMask_Status == FALSE) return Pixel;
	
	if(v_vPosition.x >= TransparencyMask_BBox.x && v_vPosition.y >= TransparencyMask_BBox.y + 1.0 && v_vPosition.x <= TransparencyMask_BBox.z && v_vPosition.y <= TransparencyMask_BBox.a + 1.0) return Transparent;
	
	return Pixel;
	
}


vec4 DoSilouetteMask(vec4 Pixel){
	
	if(SilouetteMask_Status == FALSE) return Pixel;
	
	for(int i = 0; i < SilouetteMaskCount; i++){
		if(v_vPosition.x < SilouetteMask_BBox[i].x && v_vPosition.y < SilouetteMask_BBox[i].y + 1.0 && v_vPosition.x > SilouetteMask_BBox[i].z && v_vPosition.y > SilouetteMask_BBox[i].a + 1.0){
			return Silouette;
		}
	}
	return Pixel;
	
}

float YUVval(vec4 _rgb){
    return dot(YUVWeights, _rgb.rgb);
}

vec4 DoColor(vec4 Pixel){

	if(Color_Status == FALSE) return Pixel;
	
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
    
	if(PaletteStatus == FALSE) return Pixel;
	
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



vec4 DoLighting(vec4 Pixel){
		
	if(LightingStatus == FALSE) return vec4(1.0) * Pixel;
	
	if(RoomLightingStatus[0] == FALSE && v_vPosition.x >= RoomLightingBoundary[0].x && v_vPosition.x <= RoomLightingBoundary[0].z + 1.0 && v_vPosition.y >= RoomLightingBoundary[0].y && v_vPosition.y <= RoomLightingBoundary[0].a + 1.0) return vec4(1.0) * Pixel;
	if(RoomLightingStatus[1] == FALSE && v_vPosition.x >= RoomLightingBoundary[1].x && v_vPosition.x <= RoomLightingBoundary[1].z + 1.0 && v_vPosition.y >= RoomLightingBoundary[1].y && v_vPosition.y <= RoomLightingBoundary[1].a + 1.0) return vec4(1.0) * Pixel;
	
    vec4 Light = vec4(AMB, 1.0); //start with Room ambiance as the base light
	
	if(LightingStatus_Lights == FALSE) return Light * Pixel;
	
    for(int i = 0; i < LightCount; i++){
			
		if(L_P2[i].a == TRUE){ //if Status
			
			float Strength = L_P2[i].r;
			float InRoom0 = L_P2[i].g;
			float InRoom1 = L_P2[i].b;
			
			float DoLight = FALSE;
			
			if( InRoom0 == TRUE ){
				if( v_vPosition.x >= RoomLightingBoundary[0].x && v_vPosition.x <= RoomLightingBoundary[0].z && v_vPosition.y >= RoomLightingBoundary[0].y && v_vPosition.y <= RoomLightingBoundary[0].a )
					DoLight = TRUE;
			}
			if( InRoom1 == TRUE ){
				if( v_vPosition.x >= RoomLightingBoundary[1].x && v_vPosition.x <= RoomLightingBoundary[1].z && v_vPosition.y >= RoomLightingBoundary[1].y && v_vPosition.y <= RoomLightingBoundary[1].a )
					DoLight = TRUE;
			}
			
			if(DoLight == TRUE){
				float Distance = length(L[i].xy - v_vPosition) / Strength;
				float Intensity = max(2.2 / (1.0 + pow(e, (Distance / 9.0) - 2.0)), BaseLight);
				Light.rgb += (Intensity * L_P1[i].rgb);
			}

		}
		
    }
	
	return Light * Pixel;
	
}



void main(){

	gl_FragColor = DoLighting(DoColor(DoTransparencyMask(DoSilouetteMask(DoPalette(texture2D( gm_BaseTexture, v_vTexcoord))))));
	
}

