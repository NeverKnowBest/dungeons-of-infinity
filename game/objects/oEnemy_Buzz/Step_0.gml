event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Standing);
}

PauseCheck


if(WallCollide_X){
	Buzz_UpdateDir(Dir == LEFT ? choose(RIGHT, UP, DOWN) : choose(LEFT, UP, DOWN));
}else if(WallCollide_Y){
	Buzz_UpdateDir(Dir == UP ? choose(DOWN, LEFT, RIGHT) : choose(UP, LEFT, RIGHT));
}

switch(State){
	case EnemyState.Walking:
		
		if(JumpLanded){
			
			Hops--;
			
			if(Hops <= 0){
				Enemy_UpdateState(EnemyState.Standing);
			}else{
				GravityStatus = true;
				vz = 2;	
			}
	
		}
		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 20;
		InWaterSprYOffset = 1;
		break;
		
	case UP:
		InWaterSprW = 16;
		InWaterSprYOffset = 1;
		break;
	case DOWN:
		InWaterSprW = 16;
		InWaterSprYOffset = 2;
		break;	
}