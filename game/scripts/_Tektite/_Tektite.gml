function Tektite_UpdateDir(_Dir){
	
	Dir = _Dir;

	switch(Dir){
		case LEFT:
			vx = -Speed;
			vy = -Speed
			break;
		case RIGHT:
			vx = Speed;
			vy = Speed;
			break;
		case UP:
			vx = Speed;
			vy = -Speed;
			break;
		case DOWN:
			vx = -Speed;
			vy = Speed;
			break;
		
	}
}