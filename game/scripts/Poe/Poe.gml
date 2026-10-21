function Poe_Update(){
	
	
	vx = 1.3 * cos((2 * T) / RoomFactorW) * TDir;
	vy = 1.6 * sin((3 * T) / RoomFactorH);

	T += TInc;
	
	if(sprite_index = sEnemy_FloatingHead){
		var _Angle = point_direction(0, 0, vx, vy) mod 360;
		image_index = floor(_Angle / 30);
		Dir = 1;
	}else{
		Dir = vx < 0 ? -1 : 1;
	}

	
}