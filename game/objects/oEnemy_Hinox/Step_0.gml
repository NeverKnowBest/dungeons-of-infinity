event_inherited(); 


if(KnockBackDone || StunDone || PushbackDone){
	//Enemy_UpdateState(distance_to_object(oWall) <= 8 ? EnemyState.Running : EnemyState.Shooting);
	Enemy_UpdateState(EnemyState.Shooting);
	if(State == EnemyState.Shooting) alarm[2] = 15; //shorten shoot delay if just got hit
}

PauseCheck

switch(State){
	
	case EnemyState.Walking:
	case EnemyState.Running:
		if(WallCollide_X) Hinox_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL), Speed);
		if(WallCollide_Y) Hinox_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL), Speed);
		break;
	
	case EnemyState.Shooting:
		
		Dir = DirFaceLink();
		Enemy_UpdateSprite(State);
		
		break;
		
}