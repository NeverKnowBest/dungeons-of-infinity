event_inherited();

SoundPaused = ObjPauseSound(Sound, SoundPaused);

if(!Init && image_index >= 2){
	Init = true;
}

if(Init){
	switch(oBoss_Aghanim.alarm[6]){
		default: 
			image_index = clamp(image_index, 2, 4);
			break;
		case 5:
		case 4:
		case 3:
			image_index = 1;
			break;
		case 2:
		case 1:
		case 0:
			image_index = 0;
			break;		
	}
	
}

switch(oBoss_Aghanim.EnergyBall_PalIndex){
	case 0:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex1, [1.3, 0.9, 0.5]);
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex2, [1.0, 0.6, 0.3]);
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex3, [1.0, 0.6, 0.3]);
		break;
	case 1:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex1, [0.5, 1.1, 1.6]);
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex2, [0.4, 0.7, 1.2]);
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex3, [0.4, 0.7, 1.2]);
		break;
}