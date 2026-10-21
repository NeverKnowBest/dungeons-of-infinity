event_inherited(); 


if(KnockBackDone || StunDone){
	Soldier_UpdateDir(oLink.Cape ? RandomDir() : DirFaceLink());
	Enemy_UpdateState(EnemyState.Running);
}

PauseCheck


switch(State){

	case EnemyState.Walking:
		if(Enemy_LinkInSight(HeadDir, SightOffset, SightDist)) Enemy_UpdateState(EnemyState.Alerted);
	case EnemyState.Running:		
		if(WallCollide_X) Soldier_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Soldier_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));
		break;
}

