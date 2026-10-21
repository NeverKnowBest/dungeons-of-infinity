event_inherited(); 

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){

	case EnemyState.Walking:
		if(WallCollide_X) Rat_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Rat_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));


		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 16;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 14;
		break;	
}