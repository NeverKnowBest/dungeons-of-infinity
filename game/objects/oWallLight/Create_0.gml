

TorchesSprX = x;
TorchesSprY = y;
TorchesImgIndex = 0;

var _r = 0.65;
var _g = 0.65;
var _b = 0.65;

LightStrength = 2.25;
LightIndex = -1;

switch(Location){
	case TOP:
		sprite_index = Status ? sWallLightT_Back : sWallLightT_Off;
		TorchesSpr = sWallLightT_Torches;
		if(Status) LightIndex = Lighting_CreateLight(RoomIndex, x + 16, y - 8, LightStrength, [_r, _g, _b]);
		TorchesSprX = x + 8;			
		break;
	case BOTTOM:
		sprite_index = Status ? sWallLightB_Back : sWallLightB_Off;
		TorchesSpr = sWallLightB_Torches;
		if(Status) LightIndex = Lighting_CreateLight(RoomIndex, x + 16, y + 24, LightStrength, [_r, _g, _b]);
		TorchesSprX = x + 8;
		break;
	case LEFT:
		sprite_index = Status ? sWallLightL_Back : sWallLightL_Off;
		TorchesSpr = sWallLightL_Torches;
		if(Status) LightIndex = Lighting_CreateLight(RoomIndex, x - 8, y + 16, LightStrength, [_r, _g, _b]);
		TorchesSprY = y + 8;
		break;
	case RIGHT:
		sprite_index = Status ? sWallLightR_Back : sWallLightR_Off;
		TorchesSpr = sWallLightR_Torches;
		if(Status) LightIndex = Lighting_CreateLight(RoomIndex, x + 24, y + 16, LightStrength, [_r, _g, _b]);
		TorchesSprY = y + 8;
		break;
}

PaletteIndex = global.Level.Index;

LastImageSpeed = image_speed;

if(Status) alarm[0] = 8;


