
if(DEBUG){
	
	if(++FPS_UpdateCounter mod 30 == 0){
		FPS_Real = fps_real;
		FPS_Game = fps;
		FPS_Updates++;
		FPS_AverageAddition += FPS_Real;
		FPS_Average = FPS_AverageAddition / FPS_Updates;
	}
	
}

if(global.MosaicDo){
	
	Mosaic_SizeIndex = Mosaic_SizeIndex + (Mosaic_Speed * Mosaic_SizeDir);

	if(Mosaic_SizeDir == 1 && Mosaic_SizeIndex >= Mosaic_SizeCount){
		Mosaic_SizeIndex = Mosaic_SizeCount - 1;
		Mosaic_SizeDir = -1;
	}
	if(Mosaic_SizeDir == -1 && Mosaic_SizeIndex <= 0){
		Mosaic_SizeIndex = 0;
		Mosaic_Size = 0;
		Mosaic_SizeDir = 1;
		Mosaic_Warp = false;
		global.MosaicDo = false;
		global.Paused = false;
		oHUD.CheckPendentSecret = true;
	}
	
	Mosaic_Size = Mosaic_Sizes[floor(Mosaic_SizeIndex)];
	
}




//if(keyboard_check(vk_shift)){
//	if(keyboard_check(vk_control)){
//		if(keyboard_check(vk_left)) MosaicAmount+=1
//		if(keyboard_check(vk_right)) MosaicAmount-=1
//	}else{
//		if(keyboard_check(vk_left)) MosaicAmount+=0.1
//		if(keyboard_check(vk_right)) MosaicAmount-=0.1
//	}
//}else{
//	if(keyboard_check_pressed(vk_left)) MosaicAmount+=0.1
//	if(keyboard_check_pressed(vk_right)) MosaicAmount-=0.1
//}

HeatDo = (global.TransitionRoomIndex == -1 && global.Level.Rooms[global.CurrentRoomIndex].Heat);
if(HeatDo){
	HeatIndex += (HeatIndexDir * 0.08);
	if(HeatIndexDir == 1 && HeatIndex > HeatIndexMax) HeatIndexDir = -1;
	if(HeatIndexDir == -1 && HeatIndex <= HeatIndexMin) HeatIndexDir = 1;
}
	
	

if(global.FadeIn){ //circle starting small and getting larger, black to full reveal
	global.FadeRadius += global.FadeRadiusV;
	global.FadeRadiusV += 0.25;
	if(global.FadeRadius >= 450){
		global.FadeIn = false;
	}
}

if(global.FadeOut){ //circle starting large and getting smaller, full reveal to black
	global.FadeRadius -= global.FadeRadiusV;
	global.FadeRadiusV -= 0.28;
	if(global.FadeRadius <= -5){
		global.FadeOut = false;
		global.RoomFadeBlackOut = true;
	}
}


global.InWaterFrame = (global.InWaterFrame + 1) mod 24;
global.InWaterImgIndex = floor(global.InWaterFrame / 8);
