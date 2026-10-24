if(DEBUG){
	Stats = false;
	FPS_Real = 0;
	FPS_Game = 0;
	FPS_UpdateCounter = 0;
	FPS_Updates = 0;
	FPS_AverageAddition = 0;
	FPS_Average = 0;
}


application_surface_draw_enable(false);

View1X = view_get_xport(1);
View1Y = view_get_yport(1);
View1W = view_get_wport(1);
View1H = view_get_hport(1);
View1X2 = View1X + View1W - 1;
View1Y2 = View1Y + View1H - 1;

uMosaic_Size = shader_get_uniform(shd_mosaic,"mosaic_size");
uMosaic_Brightness = shader_get_uniform(shd_mosaic,"mosaic_brightness");
global.MosaicDo = false;
Mosaic_ScreenBuffer = surface_create(1024, 896);
//MosaicAmounts = [266.6, 213.3, 154.5, 131.8, 77.2, 49.9];
Mosaic_Sizes = [255, 211, 166, 122, 83, 61, 55.30, 49.95, 38.8];
Mosaic_SizeIndex = 0;
Mosaic_Size = Mosaic_Sizes[0];
Mosaic_SizeCount = array_length(Mosaic_Sizes);  
Mosaic_SizeDir = 1;
Mosaic_Speed = 0;
Mosaic_Type = 0; //0 = standing, 1 = shock with sword
Mosaic_Warp = false;
Mosaic_HeatTimer = 0;

HeatDo = false;
HeatIndexMin = 1720;
HeatIndexMax = 1740;
HeatIndex = HeatIndexMin;
HeatIndexDir = 1;


CRT_Sizes = array_create(4);
CRT_Sizes[0] = 400;
CRT_Sizes[1] = 225;
CRT_Sizes[2] = CRT_Sizes[0] * 3;
CRT_Sizes[3] = CRT_Sizes[1] * 3;

global.uni_crt_sizes =                 shader_get_uniform(shd_CRT, "uni_crt_sizes");
global.uni_radial_distortion_amount =  shader_get_uniform(shd_CRT, "uni_radial_distortion_amount");
global.uni_use_radial_distortion =     shader_get_uniform(shd_CRT, "uni_use_radial_distortion");
global.uni_use_border =                shader_get_uniform(shd_CRT, "uni_use_border");
global.uni_use_RGB_separation =        shader_get_uniform(shd_CRT, "uni_use_RGB_separation");
global.uni_use_scanlines =				shader_get_uniform(shd_CRT, "uni_use_scanlines");
global.uni_use_noise =					shader_get_uniform(shd_CRT, "uni_use_noise");
global.uni_border_corner_size =        shader_get_uniform(shd_CRT, "uni_border_corner_size");
global.uni_border_corner_smoothness =  shader_get_uniform(shd_CRT, "uni_border_corner_smoothness");
global.uni_brightness =				shader_get_uniform(shd_CRT, "uni_brightness");
global.uni_noise_strength =			shader_get_uniform(shd_CRT, "uni_noise_strength");
global.uni_timer =						shader_get_uniform(shd_CRT, "uni_timer");


//Water Tiles
global.WaterTileStart1 = GetTileID(86, 0);
global.WaterTileStart2 = GetTileID(86, 1);
global.WaterTileStart3 = GetTileID(92, 0);
global.WaterTileStart4 = GetTileID(92, 1);
global.WaterTileStart5 = GetTileID(98, 0);
global.WaterTileStart6 = GetTileID(98, 1);
global.InWaterFrame = 0;
global.InWaterImgIndex = 0;

var SandStartTileY = (4 + ((DungeonLevel.LanmolasLair - 1) * 6));
global.SandTile[0] = GetTileID(42, SandStartTileY);
global.SandTile[1] = GetTileID(43, SandStartTileY);
global.SandTile[2] = GetTileID(44, SandStartTileY);
global.SandTile[3] = GetTileID(45, SandStartTileY);
global.SandTile[4] = GetTileID(42, SandStartTileY + 1);
global.SandTile[5] = GetTileID(43, SandStartTileY + 1);
global.SandTile[6] = GetTileID(44, SandStartTileY + 1);
global.SandTile[7] = GetTileID(45, SandStartTileY + 1);

global.FadeIn = false;
global.FadeOut = false;
global.FadeInRadiusStart = 5;
global.FadeOutRadiusStart = 450;
global.FadeRadius = global.FadeOutRadiusStart;
global.FadeRadiusV = 0;
global.RoomFadeSurface = surface_create(256, 224);
global.RoomFadeBlackOut = false;

instance_create_layer(0,0,"ObjsHighest", oDepthDrawObjs);
instance_create_layer(0,0,"ObjsHigher_Upper", oDepthDrawObjs);
instance_create_layer(0,0,"Objs_Upper", oDepthDrawObjs);
instance_create_layer(0,0,"ObjsHigher_Lower", oDepthDrawObjs);
instance_create_layer(0,0,"Objs_Lower", oDepthDrawObjs);

function FadeIn(){
	global.FadeRadius = global.FadeInRadiusStart;
	global.FadeRadiusV = 5;
	global.FadeIn = true;
	global.RoomFadeBlackOut = false;
}
function FadeOut(){
	global.FadeRadius = global.FadeOutRadiusStart;
	global.FadeRadiusV = 16;
	global.FadeOut = true;
}

// Cheat watermark

WinSizeMult = 4;
CheatWatermarkSize = 16 * WinSizeMult;

ScreenBoundaryLeft = 289;
ScreenBoundaryRight = 289 + View1W - CheatWatermarkSize;
ScreenBoundaryTop = 0;
ScreenBoundaryBottom = 0 + View1H - CheatWatermarkSize;
CheatWatermarkX = 0;
CheatWatermarkY = 0;
CheatWatermarkVsp = 1;
CheatWatermarkHsp = 1;

