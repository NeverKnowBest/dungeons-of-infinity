PauseImage

var i = (image_index * 0.1);
switch(oBoss_Aghanim.EnergyBall_PalIndex){
	case 0:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [1.3 - i, 0.9 - i, 0.5 - i]);
		break;
	case 1:
		Lighting_UpdateLight_RGB(RoomIndex, LightIndex, [0.5 - i, 1.1 - i, 1.6 - i]);
		break;
}

Lighting_UpdateLight_Radius(RoomIndex, LightIndex, 0.6 - i)