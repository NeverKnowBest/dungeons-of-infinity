function SnapDragon_UpdateDir(_Dir){
	
	Dir = _Dir;
	Enemy_UpdateSprite(State);	
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