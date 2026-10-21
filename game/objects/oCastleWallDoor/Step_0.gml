if(Closed){
	
	if(Opened){
		image_index = 1;
		audio_play_sound_stopall(Sound_Secret);
		var WallInst = instance_position(x, y, oWall);
		WallObj_Cutout_H(WallInst, x + 8, x + 23);
		var _WallInst = WallObj_Create("Objs_Upper", x, y, 4, 3);
		_WallInst.BlockLink = false;
		_WallInst.BlockLinkCarry = true;
		Closed = false;
	}
}