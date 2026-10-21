event_inherited();

if(KnockBackDone || StunDone){
	Enemy_UpdateState(EnemyState.Walking);
}

PauseCheck

switch(State){

	case EnemyState.Walking:
		if(WallCollide_X) Gibdo_UpdateDir(Enemy_WallCollisionNewDir(HORIZONTAL));
		if(WallCollide_Y) Gibdo_UpdateDir(Enemy_WallCollisionNewDir(VERTICAL));


		break;
}