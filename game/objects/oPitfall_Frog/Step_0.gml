event_inherited();

if(Jumping){
	vy+=0.14;
	
	if(y >= MaxY){
		y = MaxY;
		vx = 0;
		vy = 0;		
		alarm[1] = 25;
		image_index = 0;
		Jumping = false;
	}
}
