event_inherited(); 


if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Running);
}

PauseCheck

switch(State){
	
	case EnemyState.Walking:
	case EnemyState.Running:
		if(WallCollide_X) Rope_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Rope_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 18;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 16;
		break;	
}