/// @description Change Dir

if(ShotCount <= 0){
	ShotCount = 0;
	exit;
}

switch(Dir){
	case LEFT:	Dir = UP; break;
	case RIGHT:	Dir = DOWN;	break;
	case UP:	Dir = RIGHT;break;
	case DOWN:	Dir = LEFT;	break;
}
Enemy_UpdateSprite(State);

alarm[4] = ShotDelay;