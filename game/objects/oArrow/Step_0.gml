event_inherited();

PauseObj

if(vx == 0 && vy < 0){ //shooting up only
	var ArrowSwitchInst = instance_position(x, y - 2, oArrowSwitch);
	if(ArrowSwitchInst != noone && ArrowSwitchInst.FloorLevel == FloorLevel){
		ArrowSwitchInst.Activated = true;
		vy = 0;
		ObjSetY(ArrowSwitchInst.y + 6);
	}
}

if(WallCollided){
	 //Once obj is done colliding with wall after delay. See alarm0 in oProjectile
	vx = 0;
	vy = 0;
	image_index = 2;
	ObjSetImageSpeed(1);
	audio_play_sound_stopall(Sound_Arrow_Hit);

	WallCollided = false;

}



if(image_index >= image_number - 1 && !DestroyTimer){
	alarm[0] = 60;
	image_index = 3;
	ObjSetImageSpeed(0);
	DestroyTimer = true;
}
	
x += vx;
ObjSetY(y_base + vy);

