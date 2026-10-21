/// @description Increment eye
if(EyeMove){
	EyeA = (EyeA + 6) mod 360;
	EyeImgIndex = (EyeA + 15) / 30;
	Lighting_UpdateLight_Pos(RoomIndex, EyeLight, EyeX, EyeY);
	Lighting_UpdateLight_Visible(RoomIndex, EyeLight, EyeA < 48 || EyeA > 142);
}
alarm[0] = EyeMoveDelay;
