event_inherited(); 

if(KnockBackDone || StunDone){
	Soldier_UpdateDir(DirFaceLink());
	Enemy_UpdateState(EnemyState.Shooting);
	alarm[2] = 15;
}

PauseCheck


switch(State){

	case EnemyState.Walking:
		if(Enemy_LinkInSight(HeadDir, SightOffset, SightDist)) Enemy_UpdateState(EnemyState.Shooting);
		else if (WallCollide_X || WallCollide_Y) Enemy_UpdateState(EnemyState.Standing);
		break;
}

switch(Dir){
	case LEFT:
	case RIGHT:
		InWaterSprW = 18;
		break;
		
	case UP:
	case DOWN:
		InWaterSprW = 22;
		break;	
}