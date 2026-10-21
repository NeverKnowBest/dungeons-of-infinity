function Crab_UpdateDir(){
	
	Dir = RandomDir();

	switch(Dir){
	
		case LEFT:
		case RIGHT:
			vx = choose(-1, 1) * Speed * 3;
			vy = 0;
			ObjSetImageSpeed(1)
			break;
	
		case UP:
		case DOWN:
			vx = 0;
			vy = choose(-1, 1) * Speed;
			ObjSetImageSpeed(0.5)
	}
	
	alarm[0] = irandom_range(30, 120);

}